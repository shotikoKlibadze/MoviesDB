//
//  Movie.swift
//  Core
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation

// MARK: - Welcome
public struct MovieResponse: Codable {
    let page: Int
    let movies: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
public struct Movie: Codable {
   public let adult: Bool
   public let bigPoster: String
   public let genreIDS: [Int]
   public let id: Int
   public let originalLanguage, originalTitle, overview: String
   public let popularity: Double
   public let smallPoster, releaseDate, title: String
   public let video: Bool
   public let voteAverage: Double
   public let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case bigPoster = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case smallPoster = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
