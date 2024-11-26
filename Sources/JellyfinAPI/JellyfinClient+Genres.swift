//
//  JellyfinClient+Genres.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/26.
//

import Foundation

extension JellyfinClient {
    public func getGenres(
        folderID: String?,
        includeItemTypes: [ItemKind]? = nil,
        excludeItemTypes: [ItemKind]? = nil
    ) async throws -> [Item] {
        let items = try await underlyingClient.GetGenres(
            query: .init(
                parentId: folderID,
                excludeItemTypes: excludeItemTypes,
                includeItemTypes: includeItemTypes,
                enableImageTypes: [.Primary],
                userId: userID,
                sortOrder: [.Descending]
            )
        ).ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }

    public func getGenres(
        folderIDs: [String],
        includeItemTypes: [ItemKind]? = nil,
        excludeItemTypes: [ItemKind]? = nil
    ) async throws -> [Item] {
        try await withThrowingTaskGroup(of: [Item].self) { taskGroup in
            for folderID in folderIDs {
                taskGroup.addTask {
                    try await self.getGenres(
                        folderID: folderID,
                        includeItemTypes: includeItemTypes,
                        excludeItemTypes: excludeItemTypes
                    )
                }
            }
            var genres = [Item]()
            for try await subGenres in taskGroup {
                genres.append(contentsOf: subGenres)
            }
            return genres
        }
    }
}
