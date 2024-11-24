//
//  NameIdPair.swift
//  JellyfinAPI
//
//  Created by Xianhe Meng on 2024/11/24.
//

import Foundation

public struct NameIdPair {
    public let name: String
    public let id: String
}

protocol NameIdPairProtocol {
    var Name: String? { get }
    var Id: String? { get }
}

extension NameIdPairProtocol {
    var NameIdPair: NameIdPair {
        .init(name: Name ?? "", id: Id!)
    }
}

extension Components.Schemas.NameGuidPair: NameIdPairProtocol { }
