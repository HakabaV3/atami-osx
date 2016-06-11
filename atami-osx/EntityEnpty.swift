//
//  EntityEnpty.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/11.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki
struct EntityEmpty {}


extension EntityEmpty: Decodable {
    static func decode(e: Extractor) throws -> EntityEmpty {
        return EntityEmpty()
    }
}
