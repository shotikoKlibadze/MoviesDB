//
//  TvSeriesLocalDataSource.swift
//  Core
//
//  Created by Shotiko Klibadze on 01.06.22.
//

import Foundation

public protocol TvSeriesLocalDataSourceInterface {
    func fetchFavoriteTvSeries() async -> [MovieCoreDataEntity]
}


public class TvSeriesLocalDataSource:  TvSeriesLocalDataSourceInterface {
 
    let manager = CoreDataManager.shared
    
    public init () {}
    
    public func fetchFavoriteTvSeries() async -> [MovieCoreDataEntity] {
        let managedContext = manager.persistentContainer.viewContext
        let fetchRequest = MovieCoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isTvSeries == 1")
        var data = [MovieCoreDataEntity]()
        do {
            data = try managedContext.fetch(fetchRequest)
        } catch {
            let error = DBError(errorMessage: "Couldn't fetch favorite movies", debugMessage: "CoreDataError", endPoint: "Storage")
            ErrorHandler.shared.handleError(error: error)
        }
        return data
    }
    
}
