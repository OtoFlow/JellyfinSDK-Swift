//
//  JellyfinClient.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public typealias ItemKind = Components.Schemas.BaseItemKind

public final class JellyfinClient {
    public struct Configuration {
        public let serverURL: URL
        public let client: String
        public let version: String
        public let deviceName: String
        public let deviceID: String

        public init(
            serverURL: URL,
            client: String,
            version: String,
            deviceName: String,
            deviceID: String
        ) {
            self.serverURL = serverURL
            self.client = client
            self.version = version
            self.deviceName = deviceName
            self.deviceID = deviceID
        }
    }

    public let configuration: Configuration

    public private(set) var userID: String?
    public private(set) var accessToken: String?

    let underlyingClient: any APIProtocol

    private(set) var authenticationMiddleware: AuthenticationMiddleware?

    init(configuration: Configuration, underlyingClient: any APIProtocol) {
        self.configuration = configuration
        self.underlyingClient = underlyingClient
    }

    public convenience init(
        configuration: Configuration,
        userID: String? = nil,
        accessToken: String? = nil
    ) {
        let authenticationMiddleware = AuthenticationMiddleware(
            client: configuration.client,
            device: configuration.deviceName,
            deviceID: configuration.deviceID,
            version: configuration.version,
            userID: userID,
            accessToken: accessToken
        )

        self.init(
            configuration: configuration,
            underlyingClient: Client(
                serverURL: configuration.serverURL,
                configuration: .init(
                    dateTranscoder: .iso8601WithFractionalSeconds
                ),
                transport: URLSessionTransport(),
                middlewares: [
                    authenticationMiddleware
                ]
            )
        )

        self.userID = userID
        self.accessToken = accessToken
        self.authenticationMiddleware = authenticationMiddleware
    }
}

extension JellyfinClient {
    public func getPublicSystemInfo() async throws -> Components.Schemas.PublicSystemInfo {
        let response = try await underlyingClient.GetPublicSystemInfo()
        let systemInfo = try response.ok.body.json
        return systemInfo
    }

    public func login(username: String, password: String) async throws -> Components.Schemas.AuthenticationResult {
        let input = Operations.AuthenticateUserByName.Input(
            body: .json(
                .init(
                    value1: .init(
                        Username: username,
                        Pw: password
                    )
                )
            )
        )

        let result = try await underlyingClient.AuthenticateUserByName(input)
            .ok.body.json

        guard let user = result.User,
              let userID = user.value1.Id,
              let serverID = user.value1.ServerId,
              let accessToken = result.AccessToken
        else {
            throw Error.dataMissing
        }

        self.userID = userID
        self.accessToken = accessToken
        authenticationMiddleware?.userID = userID
        authenticationMiddleware?.accessToken = accessToken

        return result
    }
}

extension JellyfinClient {
    enum Error: Swift.Error {
        case dataMissing
    }
}
