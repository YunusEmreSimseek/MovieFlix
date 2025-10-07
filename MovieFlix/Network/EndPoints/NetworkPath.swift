//
//  NetworkPath.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Foundation

enum NetworkPath: NetworkPathProtocol {
    case popularMovies
    case trendingMovies
    case upcomingMovies
    case topratedMovies
    case trendingTVs
    case image(path: String)

    var value: String {
        switch self {
        case .popularMovies:
            return "movie/popular"
        case .trendingMovies:
            return "trending/movie/day"
        case .upcomingMovies:
            return "movie/upcoming"
        case .topratedMovies:
            return "movie/top_rated"
        case .trendingTVs:
            return "trending/tv/day"
        case .image(let path):
            return path
        }
    }

    var baseURL: URL {
        switch self {
        case .popularMovies:
            return NetworkPath.baseApiURL
        case .trendingMovies:
            return NetworkPath.baseApiURL
        case .upcomingMovies:
            return NetworkPath.baseApiURL
        case .topratedMovies:
            return NetworkPath.baseApiURL
        case .trendingTVs:
            return NetworkPath.baseApiURL
        case .image:
            return URL(string: "https://image.tmdb.org/t/p/w500/")!
        }
    }

    private static let baseApiURL = URL(string: "https://api.themoviedb.org/3/")!
}

protocol NetworkPathProtocol {
    var value: String { get }
    var baseURL: URL { get }
}
