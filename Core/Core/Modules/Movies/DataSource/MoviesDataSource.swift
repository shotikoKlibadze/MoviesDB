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
    
    public func getUpcomingMovies()  async throws -> [Movie] {
        let path = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        let data = try await networkCall.sendAsyncRequest(path: path)
        return data.results
       
    }
    
    public func getTopRatedMovies() async throws -> [Movie] {
        let path = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        let data = try await networkCall.sendAsyncRequest(path: path)
        
        return data.results
    }
    
    public func getNowPlayingMovies() async throws -> [Movie] {
        let path = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)&language=en-US&page=1"
        let networkCall = NetworkManager<MovieResponse>.shared
        let data = try await networkCall.sendAsyncRequest(path: path)
        return data.results
    }
    
}
