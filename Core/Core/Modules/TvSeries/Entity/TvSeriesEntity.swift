//
//  TvSeriesEntity.swift
//  Core
//
//  Created by Shotiko Klibadze on 01.06.22.
//

import Foundation

public class TvSeriesEntity {
    
    public let id : Int
    public let poster : String
    public let wallPaper : String?
    public let genreIDS : [Int]
    public let tittle : String
    public let releaseDate : String
    public let voteAvarage : String
    public let overview : String
    public var isFavorite : Bool
    public var cast : [ActorEntity]?
    
    public init(id: Int, poster: String, wallPaper: String?, genreIDS: [Int], tittle: String, releaseDate: String, voteAvarage: String, overview : String, isFavorite: Bool, cast: [ActorEntity]?) {
        self.id = id
        self.poster = poster
        self.wallPaper = wallPaper
        self.genreIDS = genreIDS
        self.tittle = tittle
        self.releaseDate = releaseDate
        self.voteAvarage = voteAvarage
        self.overview = overview
        self.isFavorite = isFavorite
        self.cast = cast
    }
    
    public func setFavorite(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
}

extension TvSeriesEntity : Hashable {
    
    public static func == (lhs: TvSeriesEntity, rhs: TvSeriesEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
