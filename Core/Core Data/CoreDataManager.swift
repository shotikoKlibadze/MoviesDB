//
//  Storage.swift
//  Core
//
//  Created by Shotiko Klibadze on 03.05.22.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    let identifier : String = "shotikoKlibadze.Core"
    let model : String = "MoviesDB"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let coreBundle = Bundle(identifier: identifier)
        let modelURL = coreBundle!.url(forResource: model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedContext : NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private init () {
        
    }
    
    public func save(movie: MovieEntity, movieCast: [ActorEntity]) {
        let favoriteMove = MovieCoreDataEntity(context: managedContext)
        guard let actors = favoriteMove.actors.mutableCopy() as? NSMutableSet else { return }
        
        movieCast.forEach { castMember in
            let actor = ActorCoreDataEntity(context: managedContext)
            actor.id = Int32(castMember.id)
            actor.profilePic = castMember.profilePic ?? ""
            actor.name = castMember.name
            actor.characterPlayed = castMember.characterPlayed ?? ""
            actors.add(actor)
            
        }
        
        favoriteMove.id = Int32(movie.id)
        favoriteMove.genreIDS = movie.genreIDS.map({NSNumber(value: $0)})
        favoriteMove.isFavorite = movie.isFavorite
        favoriteMove.overview = movie.overview
        favoriteMove.poster = movie.poster
        favoriteMove.releaseDate = movie.releaseDate
        favoriteMove.tittle = movie.tittle
        favoriteMove.voteAvarage = movie.voteAvarage
        favoriteMove.wallPaper = movie.wallPaper
        favoriteMove.actors = actors
        favoriteMove.isTvSeries = movie.isTvSeries
             
        do {
            try managedContext.save()
        } catch {
            let error = DBError(errorMessage: "Couldn't save movie", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
        
    }
    
    public func deleteMovie(movie: MovieEntity) {
        
        let fetchRequest = MovieCoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(integerLiteral: movie.id))
        fetchRequest.includesPropertyValues = false
     
        do {
            let objects = try managedContext.fetch(fetchRequest)
            objects.forEach({managedContext.delete($0)})
            try managedContext.save()
        } catch {
            let error = DBError(errorMessage: "Couldn't remove movie", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
    }
}
