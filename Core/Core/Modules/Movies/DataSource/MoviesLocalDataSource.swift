//
//  MoviesLocalDataSource.swift
//  Core
//
//  Created by Shotiko Klibadze on 03.05.22.
//

import Foundation

public protocol MoviesLocalDataSourceInterface {
    func fetchFavoriteMovies() -> [FavoriteMovieEntity]
}

public class MoviesLocalDataSource : MoviesLocalDataSourceInterface {
    
    let manager = CoreDataManager.shared
    
    public init () {}
    
    public func fetchFavoriteMovies() -> [FavoriteMovieEntity] {
        let managedContext = manager.persistentContainer.viewContext
        let fetchRequest = FavoriteMovieEntity.fetchRequest()
        var data = [FavoriteMovieEntity]()
        do {
            data = try managedContext.fetch(fetchRequest)
        } catch {
            let error = DBError(errorMessage: "Couldn't fetch favorite movies", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
        return data
    }
}
