//
//  JellyfinClient+Items.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

extension JellyfinClient {
    public func getItems(
        types: [Components.Schemas.BaseItemKind]? = nil,
        genres: [String]? = nil,
        filters: [Components.Schemas.ItemFilter]? = nil,
        sortBy: [Components.Schemas.ItemSortBy]? = nil,
        sortOrder: Components.Schemas.SortOrder? = nil,
        startIndex: Int? = nil,
        limit: Int? = nil,
        isRecursive: Bool = true,
        parentID: String? = nil,
        enableUserData: Bool = false,
        artistIds: [String]? = nil,
        albums: [String]? = nil
    ) async throws -> [Item] {
        let input = Operations.GetItems.Input(
            query: .init(
                userId: userID,
                startIndex: startIndex.map(Int32.init),
                limit: limit.map(Int32.init),
                recursive: isRecursive,
                sortOrder: sortOrder.map { [$0] },
                parentId: parentID,
                fields: [.MediaSources],
                includeItemTypes: types,
                filters: filters,
                sortBy: sortBy,
                genres: genres,
                enableUserData: enableUserData,
                artistIds: artistIds,
                albums: albums
            )
        )
        let response = try await underlyingClient.GetItems(input)
        let items = try response.ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }
}
