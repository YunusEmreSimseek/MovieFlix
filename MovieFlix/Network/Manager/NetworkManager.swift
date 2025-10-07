//
//  NetworkManager.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

import Alamofire
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let decoder: JSONDecoder = .init()
    private let session: Session = .default

    private init(
    ) {
        decoder.dateDecodingStrategy = .iso8601
    }

    /// Sends a network request and decodes the response into the specified type.
    /// - Parameters:
    ///   - path: Network path conforming to `NetworkPathProtocol`
    ///   - method: HTTP method to use for the request
    ///   - type: The type to decode the response into
    ///   - body: Optional request body conforming to `Encodable`
    ///   - parameter: Optional URL parameters
    /// - Returns: A `Result` containing the decoded response or an error
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        parameter: Parameters? = nil
    ) async -> Result<T, Error> {
        let url = "\(path.baseURL)\(path.value)"
        var headers: HTTPHeaders = ["Accept": "application/json"]
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_BEARER_TOKEN") as? String {
            headers.add(.authorization(bearerToken: token))
        }

        let request: DataRequest
        if let body = body {
            request = session.request(url, method: method.alamofireMethod, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
        } else {
            request = session.request(url, method: method.alamofireMethod, parameters: parameter, headers: headers)
        }
        let response = await request
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response

        guard let responseValue = response.value else {
            return .failure(response.error ?? NetworkError.unknown)
        }

        return .success(responseValue)
    }

    func sendData(path: NetworkPathProtocol, method: NetworkMethod, parameter: Parameters?) async -> Result<Data, Error> {
        let url = "\(path.baseURL)\(path.value)"
        let headers = HTTPHeaders([.accept("image/*")])
        let response = await session.request(url, method: method.alamofireMethod, parameters: parameter, headers: headers)
            .validate(contentType: ["image/png", "image/jpeg", "image/webp", "image/*"])
            .serializingData()
            .response
        guard let responseValue = response.data else { return .failure(response.error ?? NetworkError.unknown) }
        return .success(responseValue)
    }
}
