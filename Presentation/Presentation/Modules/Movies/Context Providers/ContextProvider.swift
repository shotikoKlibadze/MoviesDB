//
//  ContextProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import Foundation
import Core

protocol ContextProvider {
    func provideContext()  async throws -> [Movie]
}

class UpcomingMoviesProvider : ContextProvider {
    
    var viewModel : MoviesViewModel!
  
    init() {
    }
    
    func provideContext() async throws  -> [Movie] {
       return try await viewModel.getUpcomingMovies()
    }
  
}

class TopRatedMoviesProvider : ContextProvider {

    var viewModel : MoviesViewModel!
    var movies = [Movie]()

    init() {}

    func provideContext() async throws -> [Movie] {
        return try await viewModel.getTopRatedMovies()
    }
    
}
