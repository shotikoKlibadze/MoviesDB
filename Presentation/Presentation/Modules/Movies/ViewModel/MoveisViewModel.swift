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
    
    func getUpcomingMovies() {
        dataSource.getUpcomingMovies().subscribe(onNext: { [weak self] movies in
            self?.upcomingMoviesPR.accept(movies)
        }, onError: { [weak self] error in
            self?.moviesErrorPR.accept(error as! DBError)
        }).disposed(by: bag)
    }
    
    func getTopRatedMovies() async throws -> [Movie] {
        return try await dataSource.getTopRatedMovies()
    }
    
    func getNowPlayingMovies() async throws -> [Movie] {
        return try await dataSource.getNowPlayingMovies()
    }
    
    
    
}
