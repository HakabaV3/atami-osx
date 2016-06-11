//
//  ImageRequest.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/11.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki
import APIKit
import Result
import RxSwift

extension API {
    struct SearchImageRequest: APIRequestType {
        typealias Response = [EntityImage]

        var path: String {
            return "/image/search"
        }

        var method: HTTPMethod {
            return .GET
        }

        var keyword: String

        var parameters: AnyObject? {
            return [
                "q": keyword
            ]
        }

        func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> SearchImageRequest.Response {
            if let array = object as? [AnyJSON] {
                return try array.map({ try decodeValue($0) })
            }
            throw ResponseError.UnexpectedObject(object)
        }
    }

    static func search(keyword keyword: String) -> Observable<[EntityImage]> {
        let request = SearchImageRequest(keyword: keyword)
        return API.rx_response(request)
    }
}

extension API {
    struct  AddImageRequest: APIRequestType {
        typealias Response = EntityImage

        var path: String {
            return "/image"
        }

        var method: HTTPMethod {
            return .POST
        }

        var url: String
        var tags: [String] = []

        var parameters: AnyObject? {
            return [
                "url": url,
                "tags": tags
            ]
        }
    }

    static func addImage(url url: String, tags: [String]) -> Observable<EntityImage> {
        let request = AddImageRequest(url: url, tags: tags)
        return API.rx_response(request)
    }
 }

extension API {
    struct DeleteImageRequest: APIRequestType {
        typealias Response = EntityEmpty

        var path: String {
            return "image/" + id
        }

        var method: HTTPMethod {
            return .DELETE
        }
        var id: String
    }

    static func deleteImage(id id: String) -> Observable<EntityEmpty> {
        let request = DeleteImageRequest(id: id)
        return API.rx_response(request)
    }
}

extension API {
    struct AddTagRequest: APIRequestType {
        typealias Response = EntityEmpty

        var path: String {
            return "/image/:id/tag"
        }

        var method: HTTPMethod {
            return .POST
        }

        var id: String
        var tags: [String]

        static func addTags(id id: String, tags: [String]) -> Observable<EntityEmpty> {
            let request = AddTagRequest(id: id, tags: tags)
            return API.rx_response(request)
        }
    }
}
