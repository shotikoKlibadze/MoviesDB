//
//  MoveisViewModel.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Core
import RxSwift
import RxCocoa


public class MoviesViewModel {
    
    var dataSource : MoviesDataRepositoryInterface
    let maxPage = 10
    var currentPage = 1
    
    public init(dataSource: MoviesDataRepositoryInterface) {
        self.dataSource = dataSource
    }
    
    func resetPagination() {
        currentPage = 1
    }
    
    func getNowPlayingMovies() async -> [MovieEntity] {
        return await dataSource.getNowPlayingMovies()
    }
    
    func getUpcomingMovies() async -> [MovieEntity] {
        return await dataSource.getUpcomingMovies(page: 1)
    }
    
    func getMoreUpcomingMovies() async -> [MovieEntity] {
        currentPage += 1
        guard currentPage <= maxPage else { return [] }
        return await dataSource.getUpcomingMovies(page: currentPage)
    }
    
    func getTopRatedMovies() async -> [MovieEntity] {
        return await dataSource.getTopRatedMovies(page: currentPage)
    }
    
    func getMoreTopRatedMovies() async -> [MovieEntity] {
        currentPage += 1
        guard currentPage <= maxPage else { return [] }
        return await dataSource.getTopRatedMovies(page: currentPage)
    }
    
    func getSimilarMoives(movieID: Int) async -> [MovieEntity] {
        return await dataSource.getSimilarMovies(movieID: movieID)
    }
    
    func getCastMembers(movieID: Int) async -> [ActorEntity] {
        return await dataSource.getCastMembers(movieID: movieID)
    }
    
    func getFavoriteMovies() async -> [MovieEntity] {
        return await dataSource.getFavoriteMovies()
    }
    
}
