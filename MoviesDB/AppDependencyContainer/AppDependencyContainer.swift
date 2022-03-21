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
        let dataSource = MoviesDataSource()
        let viewModel = MoviesViewModel(dataSource: dataSource)
        return viewModel
    }
    
    func getTvSeriesViewModel() -> TvSeriesViewModel {
        let dataSource = TvSeriesDataSource()
        let viewModel = TvSeriesViewModel(dataSource: dataSource)
        return viewModel
    }
    
    
}
