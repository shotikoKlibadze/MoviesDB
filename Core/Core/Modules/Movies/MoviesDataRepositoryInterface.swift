//
//  MoviesDataRepositoryInterface.swift
//  Core
//
//  Created by Shotiko Klibadze on 03.05.22.
//

import Foundation
import CoreMedia

public protocol MoviesDataRepositoryInterface {
    //Remote
    func getUpcomingMovies(page: Int) async -> [MovieEntity]
    func getTopRatedMovies(page: Int) async -> [MovieEntity]
    func getNowPlayingMovies() async -> [MovieEntity]
    func getSimilarMovies(movieID: Int) async -> [MovieEntity]
    func getCastMembers(movieID: Int) async -> [ActorEntity]
    //Local
    func getFavoriteMovies() async -> [MovieEntity]
}

public class MoviesDataRepository : MoviesDataRepositoryInterface {
   
    let remoteDataSource : MoviesRemoteDataSourceInterface
    let localDataSource : MoviesLocalDataSourceInterface
    
    public init(remoteDataSource : MoviesRemoteDataSourceInterface, localDataSource : MoviesLocalDataSourceInterface) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getUpcomingMovies(page: Int) async -> [MovieEntity] {
        let movieData = await remoteDataSource.getUpcomingMovies(page: page)
        let favoriteMovieIDs = await getFavoriteMovieIDs()
        let entities = movieData.map { movieData -> MovieEntity in
            let isFavorite = favoriteMovieIDs.contains(movieData.id)
            let entity = MovieEntity(id: movieData.id, poster: movieData.posterPath ?? "", wallPaper: movieData.backdropPath, genreIDS: movieData.genreIDS, tittle: movieData.originalTitle, releaseDate: movieData.releaseDate, voteAvarage: String(movieData.voteAverage), overview: movieData.overview, isFavorite: isFavorite, cast: nil,isTvSeries: false)
            return entity
            
        }
        return entities
    }
    
    public func getTopRatedMovies(page: Int) async -> [MovieEntity] {
        let movieData = await remoteDataSource.getTopRatedMovies(page: page)
        let favoriteMovieIDs = await getFavoriteMovieIDs()
        let entities = movieData.map { movieData -> MovieEntity in
            let isFavorite = favoriteMovieIDs.contains(movieData.id)
            let entity = MovieEntity(id: movieData.id, poster: movieData.posterPath ?? "", wallPaper: movieData.backdropPath, genreIDS: movieData.genreIDS, tittle: movieData.originalTitle, releaseDate: movieData.releaseDate, voteAvarage: String(movieData.voteAverage), overview: movieData.overview, isFavorite: isFavorite, cast: nil, isTvSeries: false)
            return entity
            
        }
        return entities
    }
    
    public func getNowPlayingMovies() async -> [MovieEntity] {
        let movieData = await remoteDataSource.getNowPlayingMovies()
        let favoriteMovieIDs = await getFavoriteMovieIDs()
        let entities = movieData.map { movieData -> MovieEntity in
            let isFavorite = favoriteMovieIDs.contains(movieData.id)
            let entity = MovieEntity(id: movieData.id, poster: movieData.posterPath ?? "", wallPaper: movieData.backdropPath, genreIDS: movieData.genreIDS, tittle: movieData.originalTitle, releaseDate: movieData.releaseDate, voteAvarage: String(movieData.voteAverage), overview: movieData.overview, isFavorite: isFavorite, cast: nil,isTvSeries: false)
            return entity
            
        }
        return entities
    }
    
    public func getSimilarMovies(movieID: Int) async -> [MovieEntity] {
        let movieData = await remoteDataSource.getSimilarMovies(movieID: movieID)
        let favoriteMovieIDs = await getFavoriteMovieIDs()
        let entities = movieData.map { movieData -> MovieEntity in
            let isFavorite = favoriteMovieIDs.contains(movieData.id)
            let entity = MovieEntity(id: movieData.id, poster: movieData.posterPath!, wallPaper: movieData.backdropPath, genreIDS: movieData.genreIDS, tittle: movieData.originalTitle, releaseDate: movieData.releaseDate, voteAvarage: String(movieData.voteAverage), overview: movieData.overview, isFavorite: isFavorite, cast: nil, isTvSeries: false)
            return entity
            
        }
        return entities
    }
    
    public func getCastMembers(movieID: Int) async -> [ActorEntity] {
        let actorsData = await remoteDataSource.getCastMembers(movieID: movieID)
        let entities = actorsData.map({ActorEntity(id: $0.id, name: $0.name, profilePic: $0.profilePath, characterPlayed: $0.character)})
        return entities
    }
    
    private func getFavoriteMovieIDs() async -> [Int] {
        let favoriteMovies = await localDataSource.fetchFavoriteMovies()
        let ids = favoriteMovies.map({Int($0.id)})
        return ids
    }
    
    public func getFavoriteMovies() async -> [MovieEntity] {
        let movieData = await localDataSource.fetchFavoriteMovies()
        let entities = movieData.map { movie -> MovieEntity in
            let movieCast = movie.actors.allObjects as! [ActorCoreDataEntity]
            let cast = movieCast.map {
                ActorEntity(id: Int($0.id), name: $0.name, profilePic: $0.profilePic, characterPlayed: $0.characterPlayed)
            }
            let entity = MovieEntity(id: Int(movie.id), poster: movie.poster, wallPaper: movie.wallPaper, genreIDS: movie.genreIDS.map{Int(truncating: $0)}, tittle: movie.tittle, releaseDate: movie.releaseDate, voteAvarage: movie.voteAvarage, overview: movie.overview, isFavorite: movie.isFavorite, cast: cast, isTvSeries: false)
            return entity
        }
        return entities
    }
    
    
}
