//
//  MediaFolder.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

public typealias CollectionType = Components.Schemas.CollectionType

public struct MediaFolder {
    public let id: String
    public let collectionType: CollectionType?
}

extension MediaFolder {
    static func convertFromOpenAPI(_ item: Components.Schemas.BaseItemDto) -> MediaFolder {
        MediaFolder(
            id: item.Id!,
            collectionType: item.CollectionType?.value1
        )
    }
}
