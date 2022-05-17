//
//  ActorCoreDataEntity+CoreDataProperties.swift
//  Core
//
//  Created by Shotiko Klibadze on 17.05.22.
//
//

import Foundation
import CoreData


extension ActorCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActorCoreDataEntity> {
        return NSFetchRequest<ActorCoreDataEntity>(entityName: "ActorCoreDataEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var profilePic: String
    @NSManaged public var characterPlayed: String
    @NSManaged public var movie: MovieCoreDataEntity

}

extension ActorCoreDataEntity : Identifiable {

}
