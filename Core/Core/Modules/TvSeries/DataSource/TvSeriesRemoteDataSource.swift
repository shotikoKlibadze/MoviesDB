//
//  TvSeriesDataSource.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Combine

public protocol TvSeriesRemoteDataSourceInterface {
    func getTvSeriesOnAir() -> AnyPublisher<[TvSeriesData],Error>
}


public class TvSeriesRemoteDataSource:  TvSeriesRemoteDataSourceInterface {
   
    
    
    private let key = "f4fc52063b2419f14cdaa0ac0fd23462"
    
    public init() {
        
    }
    
    public func getTvSeriesOnAir() -> AnyPublisher<[TvSeriesData], Error> {
        let path = "https://api.themoviedb.org/3/tv/on_the_air?api_key=\(key)&language=en-US&page=1"
        let networkCall = CombineNetworkManager<TvSeriesResponse>.shared
        return networkCall.sendRequest(path: path)
            .map({$0.results})
            .eraseToAnyPublisher()
    }
    
    
    
}
