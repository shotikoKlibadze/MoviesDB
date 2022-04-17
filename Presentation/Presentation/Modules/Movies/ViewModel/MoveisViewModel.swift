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
    
    let bag = DisposeBag()
    var dataSource : MoviesDataSourceInterface
    var moviesErrorPR = PublishRelay<DBError>()
    var upcomingMoviesPR = PublishRelay<[Movie]>()
    
    public init(dataSource: MoviesDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    func getNowPlayingMovies() async throws -> [Movie] {
        return try await dataSource.getNowPlayingMovies()
    }
    
    func getUpcomingMovies() async throws -> [Movie] {
        return try await dataSource.getUpcomingMovies()
    }
    
    func getTopRatedMovies() async throws -> [Movie] {
        return try await dataSource.getTopRatedMovies()
    }
    
}
