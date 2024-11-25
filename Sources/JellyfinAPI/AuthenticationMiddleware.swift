//
//  AuthenticationMiddleware.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import OpenAPIRuntime
import Foundation
import HTTPTypes

final class AuthenticationMiddleware {
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    package var userID: String?
    package var accessToken: String?

    package init(
        client: String,
        device: String,
        deviceID: String,
        version: String,
        userID: String?,
        accessToken: String?
    ) {
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
        self.userID = userID
        self.accessToken = accessToken
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    package func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = authHeaders()
        return try await next(request, body, baseURL)
    }

    private func authHeaders() -> String {
        let fields = [
            "Client": client,
            "Version": version,
            "Device": device,
            "DeviceId": deviceID,
            "UserId": userID,
            "Token": accessToken
        ]
            .compactMap { key, value in
                value.map { "\(key)=\($0)" }
            }
            .joined(separator: ", ")
        return "MediaBrowser \(fields)"
    }
}
