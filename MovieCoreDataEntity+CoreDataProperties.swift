//
//  MovieCoreDataEntity+CoreDataProperties.swift
//  Core
//
//  Created by Shotiko Klibadze on 17.05.22.
//
//

import Foundation
import CoreData


extension MovieCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreDataEntity> {
        return NSFetchRequest<MovieCoreDataEntity>(entityName: "MovieCoreDataEntity")
    }

    @NSManaged public var genreIDS: [NSNumber]
    @NSManaged public var id: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var overview: String
    @NSManaged public var poster: String
    @NSManaged public var releaseDate: String
    @NSManaged public var tittle: String
    @NSManaged public var voteAvarage: String
    @NSManaged public var wallPaper: String?
    @NSManaged public var actors: NSSet

}

// MARK: Generated accessors for actors
extension MovieCoreDataEntity {

    @objc(addActorsObject:)
    @NSManaged public func addToActors(_ value: ActorCoreDataEntity)

    @objc(removeActorsObject:)
    @NSManaged public func removeFromActors(_ value: ActorCoreDataEntity)

    @objc(addActors:)
    @NSManaged public func addToActors(_ values: NSSet)

    @objc(removeActors:)
    @NSManaged public func removeFromActors(_ values: NSSet)

}

extension MovieCoreDataEntity : Identifiable {

}
