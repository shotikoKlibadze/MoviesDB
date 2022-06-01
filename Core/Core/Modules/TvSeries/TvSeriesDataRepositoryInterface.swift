//
//  TvSeriesDataSourceInterface.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Combine

public protocol TvSeriesDataRepositoryInterface {
    func getTvSeriesOnAir() -> AnyPublisher<[TvSeriesEntity],Error>
}

public class TvSeriesDataRepository : TvSeriesDataRepositoryInterface {
   
  
    
    let localDatasource: TvSeriesLocalDataSourceInterface
    let remoteDataSource: TvSeriesRemoteDataSourceInterface
    
    public init(localDatasource: TvSeriesLocalDataSourceInterface,
                remoteDataSource: TvSeriesRemoteDataSourceInterface) {
        self.localDatasource = localDatasource
        self.remoteDataSource = remoteDataSource
    }
    
    public func getTvSeriesOnAir() -> AnyPublisher<[TvSeriesEntity], Error> {
        return remoteDataSource.getTvSeriesOnAir()
            .map{$0.map({TvSeriesEntity(id: $0.id, poster: $0.posterPath, wallPaper: $0.backdropPath, genreIDS: $0.genreIDS, tittle: $0.originalName, releaseDate: $0.firstAirDate, voteAvarage: String($0.voteAverage), overview: $0.overview, isFavorite: false, cast: nil)})}
            .eraseToAnyPublisher()
    }
    
    
}
