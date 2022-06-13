//
//  TvSeriesDataSourceInterface.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Combine

public protocol TvSeriesDataRepositoryInterface {
    func getTvSeriesOnAir() -> AnyPublisher<[MovieEntity],Error>
    func getPopularTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error>
    func getTopRatedTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error>
    
    func getSimilarTvSeries(tvSeriesID: Int) -> AnyPublisher<[MovieEntity], Error>
    func getCastMembers(tvSeriesID: Int) -> AnyPublisher<[ActorEntity], Error>
    
    func getFavoriteTvSeries() async -> [MovieEntity]
    
}

public class TvSeriesDataRepository : TvSeriesDataRepositoryInterface {
   
    let localDatasource: TvSeriesLocalDataSourceInterface
    let remoteDataSource: TvSeriesRemoteDataSourceInterface
    
    public init(localDatasource: TvSeriesLocalDataSourceInterface,
                remoteDataSource: TvSeriesRemoteDataSourceInterface) {
        self.localDatasource = localDatasource
        self.remoteDataSource = remoteDataSource
    }
    
    public func getTvSeriesOnAir() -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getTvSeriesOnAir()
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath ?? "", wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil, isTvSeries: true)})}
            .eraseToAnyPublisher()
    }
    
    public func getPopularTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getPopularTvSeries(page: page)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath ?? "", wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil, isTvSeries: true)})}
            .eraseToAnyPublisher()
    }
    
    public func getTopRatedTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getTopRatedTvSeries(page: page)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath ?? "", wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil, isTvSeries: true)})}
            .eraseToAnyPublisher()
    }
    
    public func getSimilarTvSeries(tvSeriesID: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getSimilarTvSeries(tvSeriesID: tvSeriesID)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath ?? "", wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil, isTvSeries: true)})}
            .eraseToAnyPublisher()
    }
    
    public func getCastMembers(tvSeriesID: Int) -> AnyPublisher<[ActorEntity], Error> {
        return remoteDataSource.getCastMembers(tvSeriesID: tvSeriesID)
            .map({$0.map({ActorEntity(id: $0.id, name: $0.name, profilePic: $0.profilePath, characterPlayed: $0.character)})})
            .eraseToAnyPublisher()
    }
    
    public func getFavoriteTvSeries() async -> [MovieEntity] {
        let movieData = await localDatasource.fetchFavoriteTvSeries()
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
