//
//  MediaFolder.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

public struct MediaFolder {
    let id: String
    let collectionType: Components.Schemas.CollectionType?
}

extension MediaFolder {
    static func convertFromOpenAPI(_ item: Components.Schemas.BaseItemDto) -> MediaFolder {
        MediaFolder(
            id: item.Id!,
            collectionType: item.CollectionType?.value1
        )
    }
}
