//
//  FavoriteMovieEntity+CoreDataProperties.swift
//  Core
//
//  Created by Shotiko Klibadze on 03.05.22.
//
//

import Foundation
import CoreData


extension FavoriteMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        return NSFetchRequest<FavoriteMovieEntity>(entityName: "FavoriteMovieEntity")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var overview: String?
    @NSManaged public var voteAvarage: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var tittle: String?
    @NSManaged public var genreIDS: [NSNumber]?
    @NSManaged public var wallPaper: String?
    @NSManaged public var poster: String?
    @NSManaged public var id: Int32

}

extension FavoriteMovieEntity : Identifiable {

}
