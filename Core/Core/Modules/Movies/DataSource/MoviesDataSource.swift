//
//  MoviesDataSource.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import RxSwift

public class MoviesDataSource: MoviesDataSourceInterface {
    private let key = "f4fc52063b2419f14cdaa0ac0fd23462"
    
    public init() {
    }
    
    public func getUpcomingMovies() -> Observable<[Movie]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let path = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(self.key)&language=en-US&page=1"
            let networkCall = NetworkManager<MovieResponse>.shared
            networkCall.sendRequest(path: path) { result in
                switch result {
                case .success(let moviesResponse):
                    if let movies = moviesResponse?.movies {
                        observer.onNext(movies)
                    }
                case .failure(_):
                    let error = DBError(errorMessage: "Could't load upcoming movies", endPoint: "getUpcomingMovies")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    public func getTopRatedMovies() async throws -> [Movie] {
        let path = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        let data = try await networkCall.sendAsyncRequest(path: path)
        
        return data.movies
    }
    
    
    
}
