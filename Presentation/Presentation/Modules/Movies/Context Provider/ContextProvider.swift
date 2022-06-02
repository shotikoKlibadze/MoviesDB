//
//  ContextProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import Foundation
import Core

protocol ContextProvider {
    var viewModel : MoviesViewModel! { get set }
    func provideContext() async -> [MovieEntity]
}

class UpcomingMoviesProvider : ContextProvider {
    
    var viewModel: MoviesViewModel!
    
    init() {
    }
    
    func provideContext() async   -> [MovieEntity] {
       return await viewModel.getUpcomingMovies()
    }
  
}

class TopRatedMoviesProvider : ContextProvider {

    var viewModel : MoviesViewModel!
   
    init() {}

    func provideContext() async -> [MovieEntity] {
        return await viewModel.getTopRatedMovies()
    }
    
}
