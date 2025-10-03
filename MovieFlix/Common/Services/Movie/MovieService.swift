//
//  MovieService.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

protocol MovieServiceProtocol {
    func fetchPopularMovies() async
}

final class MovieService: MovieServiceProtocol {
    private let networkManager: NetworkManager
    init() {
        networkManager = NetworkManager(config: .init(baseURL: ""))
    }

    func fetchPopularMovies() async {}
}
