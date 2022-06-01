//
//  AppDependencyContainer.swift
//  MoviesDB
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Presentation
import Core

class AppDependencyContainer: AppDependencyContainerInterface {
    
    static let appDepedencyContainer = AppDependencyContainer()
    
    func getMoviesViewModel() -> MoviesViewModel {
        let remoteDataSource = MoviesRemoteDataSource()
        let localDataSource = MoviesLocalDataSource()
        let dataRepo = MoviesDataRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        let viewModel = MoviesViewModel(dataSource: dataRepo)
        return viewModel
    }
    
    func getTvSeriesViewModel() -> TvSeriesViewModel {
        let remoteDataSource = TvSeriesRemoteDataSource()
        let localDataSource = TvSeriesLocalDataSource()
        let dataRepo = TvSeriesDataRepository(localDatasource: localDataSource, remoteDataSource: remoteDataSource)
        let viewModel = TvSeriesViewModel(dataSource: dataRepo)
        return viewModel
    }
    
    
}
