//
//  MoviesDataSource.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import RxSwift

public protocol MoviesRemoteDataSourceInterface {
    func getUpcomingMovies() async -> [MovieData]
    func getTopRatedMovies() async -> [MovieData]
    func getNowPlayingMovies() async -> [MovieData]
}

public class MoviesRemoteDataSource: MoviesRemoteDataSourceInterface {
    private let key = "f4fc52063b2419f14cdaa0ac0fd23462"
    
    public init() {
    }
    
    public func getUpcomingMovies()  async -> [MovieData] {
        let path = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        guard let data = await networkCall.sendAsyncRequest(path: path) else { return [] }
        return data.results
       
    }
    
    public func getTopRatedMovies() async -> [MovieData] {
        let path = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        guard let data = await networkCall.sendAsyncRequest(path: path) else { return [] }
        
        return data.results
    }
    
    public func getNowPlayingMovies() async -> [MovieData] {
        let path = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        guard let data = await networkCall.sendAsyncRequest(path: path) else { return [] }
        return data.results
    }
    
}
