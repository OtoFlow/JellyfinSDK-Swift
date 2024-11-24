//
//  JellyfinClient+Library.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

extension JellyfinClient {
    public func getMediaFolders() async throws -> [MediaFolder] {
        let items = try await underlyingClient.GetMediaFolders().ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }
}
