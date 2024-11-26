//
//  JellyfinClient+Lyrics.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/26.
//

import Foundation

public typealias Lyric = Components.Schemas.LyricDto

extension JellyfinClient {
    public func getLyrics(itemID: String) async throws -> Lyric {
        try await underlyingClient.GetLyrics(
            path: .init(itemId: itemID)
        ).ok.body.json
    }
}
