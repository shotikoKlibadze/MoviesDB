//
//  TopRatedMoviesProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation
import Core

class TopRatedMoviesProvider : MovieContextProvider {
    
   // typealias Context = MovieEntity
  
    var viewModel : MoviesViewModel!
   
    init() {}

    func provideContext() async -> [MovieEntity] {
        return await viewModel.getTopRatedMovies()
    }
    
    func provideMoreContext() async -> [MovieEntity] {
        return await viewModel.getMoreTopRatedMovies()
    }
    
    func resetContext() {
        viewModel.resetPagination()
    }
}
