//
//  NetworkPath.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

enum NetworkPath: String, NetworkPathProtocol {
    case login = "/login"

    var path: String {
        return self.rawValue
    }
}

protocol NetworkPathProtocol {
    var path: String { get }
}
