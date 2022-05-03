//
//  MoviesDataRepositoryInterface.swift
//  Core
//
//  Created by Shotiko Klibadze on 03.05.22.
//

import Foundation

public protocol MoviesDataRepositoryInterface {
    func getUpcomingMovies() async -> [MovieEntity]
    func getTopRatedMovies() async -> [MovieEntity]
    func getNowPlayingMovies() async -> [MovieEntity]
}

public class MoviesDataRepository : MoviesDataRepositoryInterface {
    
    let remoteDataSource : MoviesRemoteDataSourceInterface
    let localDataSource : MoviesLocalDataSourceInterface
    
    public init(remoteDataSource : MoviesRemoteDataSourceInterface, localDataSource : MoviesLocalDataSourceInterface) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getUpcomingMovies() async -> [MovieEntity] {
        let movieData = await remoteDataSource.getUpcomingMovies()
        guard !movieData.isEmpty else { return [] }
        let favoriteMovieIDs = getFavoriteMovieIDs()
        
        let entities = movieData.map { movieData -> MovieEntity in
            let isFavorite = favoriteMovieIDs.contains(movieData.id)
            let entity = MovieEntity(id: movieData.id, poster: movieData.posterPath, wallPaper: movieData.backdropPath, genreIDS: movieData.genreIDS, tittle: movieData.originalTitle, releaseDate: movieData.releaseDate, voteAvarage: String(movieData.voteAverage), overview: movieData.overview, isFavorite: isFavorite)
            return entity
            
        }
        
//        let entities = movieData.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalTitle, releaseDate: $0.releaseDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false)})
        return entities
    }
    
    public func getTopRatedMovies() async -> [MovieEntity] {
        let movieData = await remoteDataSource.getTopRatedMovies()
        guard !movieData.isEmpty else { return [] }
        let entities = movieData.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalTitle, releaseDate: $0.releaseDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false)})
        return entities
    }
    
    public func getNowPlayingMovies() async -> [MovieEntity] {
        let movieData = await remoteDataSource.getNowPlayingMovies()
        guard !movieData.isEmpty else { return [] }
        let entities = movieData.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalTitle, releaseDate: $0.releaseDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false)})
        return entities
    }
    
    private func getFavoriteMovieIDs() -> [Int] {
        let favoriteMovies = localDataSource.fetchFavoriteMovies()
        let ids = favoriteMovies.map({Int($0.id)})
        return ids
    }
   
    
}
