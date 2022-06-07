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
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil)})}
            .eraseToAnyPublisher()
    }
    
    public func getPopularTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getPopularTvSeries(page: page)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil)})}
            .eraseToAnyPublisher()
    }
    
    public func getTopRatedTvSeries(page: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getTopRatedTvSeries(page: page)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil)})}
            .eraseToAnyPublisher()
    }
    
    public func getSimilarTvSeries(tvSeriesID: Int) -> AnyPublisher<[MovieEntity], Error> {
        return remoteDataSource.getSimilarTvSeries(tvSeriesID: tvSeriesID)
            .map{$0.map({MovieEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil)})}
            .eraseToAnyPublisher()
    }
    
    public func getCastMembers(tvSeriesID: Int) -> AnyPublisher<[ActorEntity], Error> {
        return remoteDataSource.getCastMembers(tvSeriesID: tvSeriesID)
            .map({$0.map({ActorEntity(id: $0.id, name: $0.name, profilePic: $0.profilePath, characterPlayed: $0.character)})})
            .eraseToAnyPublisher()
    }
    
    
    
    
}
