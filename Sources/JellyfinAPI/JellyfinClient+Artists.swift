//
//  JellyfinClient+Artists.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

extension JellyfinClient {
    public func getArtists() async throws -> [Item] {
        let response = try await underlyingClient.GetArtists()
        let items = try response.ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }

    public func getArtist(name: String) async throws -> Item? {
        let input = Operations.GetArtistByName.Input(
            path: .init(name: name),
            query: .init(userId: userID),
            headers: .init(accept: [.init(contentType: .json)])
        )
        let response = try await underlyingClient.GetArtistByName(input)
        let item = try? response.ok.body.json
        return item.map { .convertFromOpenAPI($0) }
    }
}
