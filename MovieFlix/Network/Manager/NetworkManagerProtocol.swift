//
//  NetworkManagerProtocol.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

import Alamofire
import Foundation

protocol NetworkManagerProtocol {
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable?,
        parameter: Parameters?
    ) async -> Result<T, Error>

    func sendData(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        parameter: Parameters?
    ) async -> Result<Data, Error>
}

extension NetworkManagerProtocol {
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        parameter: Parameters? = nil
    ) async -> Result<T, Error> {
        return await send(path: path, method: method, type: type, body: body, parameter: parameter)
    }

    func sendData(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        parameter: Parameters? = nil
    ) async -> Result<Data, Error> {
        return await sendData(path: path, method: method, parameter: parameter)
    }
}
