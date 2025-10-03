//
//  NetworkManagerProtocol.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

import Alamofire

protocol NetworkManagerProtocol {
    func send<T: Decodable & Sendable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable?,
        parameter: Parameters?
    ) async -> Result<T, Error>
}

nonisolated extension NetworkManagerProtocol {
    func send<T: Decodable & Sendable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        parameter: Parameters? = nil
    ) async -> Result<T, Error> {
        return await send(path: path, method: method, type: type, body: body, parameter: parameter)
    }
}
