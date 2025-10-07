//
//  MovieService.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int) async -> MovieResult?
    func fetchTrendingMovies() async -> MovieResult?
    func fetchTopRatedMovies(page: Int) async -> MovieResult?
    func fetchUpcomingMovies(page: Int) async -> MovieResult?
    func fetchTrendingTVs() async -> MovieResult?
    func fetchMoviePosterImage(path: String) async -> Data?
}

extension MovieServiceProtocol {
    func fetchPopularMovies(page: Int = 1) async -> MovieResult? {
        return await fetchPopularMovies(page: page)
    }

    func fetchTopRatedMovies(page: Int = 1) async -> MovieResult? {
        return await fetchTopRatedMovies(page: page)
    }

    func fetchUpcomingMovies(page: Int = 1) async -> MovieResult? {
        return await fetchUpcomingMovies(page: page)
    }
}

final class MovieService: MovieServiceProtocol {
    func fetchTrendingMovies() async -> MovieResult? {
        let result = await networkManager.send(path: NetworkPath.trendingMovies, method: .GET, type: MovieResult.self)
        switch result {
        case .success(let response):
            print("Successfully fetched trending movies")
            return response
        case .failure(let error):
            print("Error fetching trending movies: \(error)")
            return nil
        }
    }

    func fetchTopRatedMovies(page: Int) async -> MovieResult? {
        let result = await networkManager.send(path: NetworkPath.topratedMovies, method: .GET, type: MovieResult.self)
        switch result {
        case .success(let response):
            print("Successfully fetched toprated movies")
            return response
        case .failure(let error):
            print("Error fetching toprated movies: \(error)")
            return nil
        }
    }

    func fetchUpcomingMovies(page: Int) async -> MovieResult? {
        let result = await networkManager.send(path: NetworkPath.upcomingMovies, method: .GET, type: MovieResult.self)
        switch result {
        case .success(let response):
            print("Successfully fetched upcoming movies")
            return response
        case .failure(let error):
            print("Error fetching upcoming movies: \(error)")
            return nil
        }
    }

    func fetchTrendingTVs() async -> MovieResult? {
        let result = await networkManager.send(path: NetworkPath.trendingTVs, method: .GET, type: MovieResult.self)
        switch result {
        case .success(let response):
            print("Successfully fetched trending tvs")
            return response
        case .failure(let error):
            print("Error fetching trending tvs: \(error)")
            return nil
        }
    }

    private let networkManager: NetworkManagerProtocol
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchPopularMovies(page: Int = 1) async -> MovieResult? {
        let result = await networkManager.send(path: NetworkPath.popularMovies, method: .GET, type: MovieResult.self)
        switch result {
        case .success(let response):
            print("Successfully fetched popular movies")
            return response
        case .failure(let error):
            print("Error fetching popular movies: \(error)")
            return nil
        }
    }

    func fetchMoviePosterImage(path: String) async -> Data? {
        let result = await networkManager.sendData(path: NetworkPath.image(path: path), method: .GET)
        switch result {
        case .success(let response):
            print("Successfully fetched poster image")
            return response
        case .failure(let error):
            print("Error fetching poster image: \(error)")
            return nil
        }
    }
}
