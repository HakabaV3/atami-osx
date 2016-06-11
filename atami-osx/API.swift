//
//  API.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/11.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Himotoki
import RxSwift

final class API {
    static func rx_response<T: APIRequestType>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = Session.sendRequest(request) { result in
                switch result {
                case .Success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            task?.resume()

            return AnonymousDisposable {
                task?.cancel()
            }
        }
    }

}

protocol APIRequestType: RequestType {
}

extension APIRequestType {
    var baseURL: NSURL {
        return NSURL(string: "https://atami.kikurage.xyz/v1")!
//        return NSURL(string: "http://amp.kikurage.xyz/api/v1")!
//        return NSURL(string: "http://private-6c279e-test7667.apiary-mock.com")!

    }
}

extension APIRequestType where Response: Decodable {
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Self.Response {
        print(object)
        print(URLResponse)
        return try decodeValue(object)
    }
}
