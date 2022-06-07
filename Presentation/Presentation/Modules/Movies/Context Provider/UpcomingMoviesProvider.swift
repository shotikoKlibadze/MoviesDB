//
//  UpcomingMoviesProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation
import Core

class UpcomingMoviesProvider : MovieContextProvider {
    
   // typealias Context = MovieEntity
    
    var viewModel: MoviesViewModel!
    
    init() {
    }
    
    func provideContext() async   -> [MovieEntity] {
       return await viewModel.getUpcomingMovies()
    }
    
    func provideMoreContext() async -> [MovieEntity] {
        return await viewModel.getMoreUpcomingMovies()
    }
    
    func resetContext() {
        viewModel.resetPagination()
    }
}
