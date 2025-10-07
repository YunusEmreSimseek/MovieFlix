//
//  Movie.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import Foundation

/// A struct representing a movie response from an API.
struct MovieResult: Decodable, Sendable {
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?

    /// Coding keys to map JSON keys to struct properties.
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

/// A struct representing a single movie result.
struct Movie: Decodable, Sendable {
    let id: Int?
    let posterPath: String?
    let overview, releaseDate, title: String?

    /// Coding keys to map JSON keys to struct properties.
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview, title
        case releaseDate = "release_date"
    }

    var _id: Int { id ?? Int.min }
    var _posterPath: String { posterPath ?? "" }
    var _overview: String { overview ?? "No Overview" }
    var _releaseDate: String { releaseDate ?? "No Release Date" }
    var _title: String { title ?? "No Title" }
}

extension Movie {
    static let dummyMovie = Movie(
        id: 2,
        posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
        overview: "A Finnish man goes to the city to find a job after the mine where he worked is closed and his father commits suicide.",
        releaseDate: "1988-10-21",
        title: "Ariel"
    )
}
