//
//  ActorEntity.swift
//  Core
//
//  Created by Shotiko Klibadze on 11.05.22.
//

import Foundation

public struct ActorEntity {

   public let id: Int
   public let name: String
   public let profilePic: String?
   public let characterPlayed: String?
    
    public init(id: Int, name: String, profilePic: String?, characterPlayed: String?) {
        self.id = id
        self.name = name
        self.profilePic = profilePic
        self.characterPlayed = characterPlayed
    }
}

extension ActorEntity : Hashable {
    
    public static func == (lhs: ActorEntity, rhs: ActorEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
