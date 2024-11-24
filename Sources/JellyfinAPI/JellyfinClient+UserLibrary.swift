//
//  JellyfinClient+UserLibrary.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

extension JellyfinClient {
    @discardableResult
    public func markFavorite(_ isFavorite: Bool, itemID: String) async throws -> UserData {
        let userData: Components.Schemas.UserItemDataDto
        if isFavorite {
            userData = try await underlyingClient.MarkFavoriteItem(
                path: .init(itemId: itemID)
            ).ok.body.json
        } else {
            userData = try await underlyingClient.UnmarkFavoriteItem(
                path: .init(itemId: itemID)
            ).ok.body.json
        }
        return .convertFromOpenAPI(userData)
    }
}
