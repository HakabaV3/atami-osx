//
//  EntityImage.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/11.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki

struct EntityImage {
    let id: String
    let tags: [String]
    let originalUrl: String
    let proxiedUrl: String

    func toDictionary() -> [String: String] {
        return [
            "id": id,
            "tags": tags.joinWithSeparator(","),
            "originalUrl": originalUrl,
            "proxiedUrl": proxiedUrl
        ]
    }

    static func fromDictionary(dict: [String: String]) -> EntityImage {
        return EntityImage(
            id: dict["id"] ?? "",
            tags: dict["tags"]?.componentsSeparatedByString(",") ?? [],
            originalUrl: dict["originalUrl"] ?? "",
            proxiedUrl: dict["proxiedUrl"] ?? ""
        )
    }
}

extension EntityImage: Decodable {
    static func decode(e: Extractor) throws -> EntityImage {
        return try EntityImage(
            id: e <| "id",
            tags: e <|| "tags",
            originalUrl: e <| "originalUrl",
            proxiedUrl: e <| "proxiedUrl"
        )
    }
}
