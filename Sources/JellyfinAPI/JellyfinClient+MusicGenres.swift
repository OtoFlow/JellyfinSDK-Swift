//
//  JellyfinClient+MusicGenres.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/26.
//

import Foundation

extension JellyfinClient {
    public func getMusicGenres(
        includeMusicVideo: Bool = false
    ) async throws -> [Item] {
        let includeCollections: [CollectionType] = includeMusicVideo ? [.music, .musicvideos] : [.music]
        let folderIDs = try await getMediaFolders()
            .filter { $0.collectionType.map(includeCollections.contains(_:)) ?? false }
            .map(\.id)
        return try await getGenres(
            folderIDs: folderIDs,
            includeItemTypes: includeMusicVideo ? [.Audio, .MusicVideo] : [.Audio]
        )
    }
}
