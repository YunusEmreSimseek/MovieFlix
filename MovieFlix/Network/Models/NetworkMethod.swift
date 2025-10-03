//
//  NetworkMethod.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

import Alamofire

enum NetworkMethod {
    case GET
    case POST
    case PUT

    var alamofireMethod: HTTPMethod {
        switch self {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        }
    }
}
