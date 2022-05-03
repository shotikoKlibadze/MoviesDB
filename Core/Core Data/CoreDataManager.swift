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
    
    
    private init () {
        
    }
    
    public func save(movie: MovieEntity) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovieEntity", in: managedContext)!
        let favoriteMoive = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favoriteMoive.setValue(movie.id, forKey: "id")
        favoriteMoive.setValue(movie.genreIDS, forKey: "genreIDS")
        favoriteMoive.setValue(movie.isFavorite, forKey: "isFavorite")
        favoriteMoive.setValue(movie.overview, forKey: "overview")
        favoriteMoive.setValue(movie.poster, forKey: "poster")
        favoriteMoive.setValue(movie.releaseDate, forKey: "releaseDate")
        favoriteMoive.setValue(movie.tittle, forKey: "tittle")
        favoriteMoive.setValue(movie.voteAvarage, forKey: "voteAvarage")
        favoriteMoive.setValue(movie.wallPaper, forKey: "wallPaper")
        
        do {
            try managedContext.save()
        } catch {
            let error = DBError(errorMessage: "Couldn't save movie", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
        
    }
    
    public func deleteMovie(movie: MovieEntity) {
        let fetchRequest : NSFetchRequest<FavoriteMovieEntity>
        fetchRequest = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(integerLiteral: movie.id))
        fetchRequest.includesPropertyValues = false
        let context = persistentContainer.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            objects.forEach({context.delete($0)})
            try context.save()
        } catch {
            let error = DBError(errorMessage: "Couldn't remove movie", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
    }

}
