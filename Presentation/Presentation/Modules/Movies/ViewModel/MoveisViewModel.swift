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
    var dataSource : MoviesDataRepositoryInterface
    
    public init(dataSource: MoviesDataRepositoryInterface) {
        self.dataSource = dataSource
    }
    
    func getNowPlayingMovies() async -> [MovieEntity] {
        return await dataSource.getNowPlayingMovies()
    }
    
    func getUpcomingMovies() async -> [MovieEntity] {
        return await dataSource.getUpcomingMovies()
    }
    
    func getTopRatedMovies() async -> [MovieEntity] {
        return await dataSource.getTopRatedMovies()
    }
    
}
