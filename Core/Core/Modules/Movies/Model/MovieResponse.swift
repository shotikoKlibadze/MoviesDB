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
    let results: [Movie]
    let totalPages, totalResults: Int
    

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
public struct Movie: Codable, Hashable {
    
   public let adult: Bool
   public let backdropPath: String?
   public let genreIDS: [Int]
   public let id: Int
   public let originalTitle, overview: String
   public let popularity: Double
   public let posterPath, releaseDate, title: String
   public let video: Bool
   public let voteAverage: Double
   public let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


