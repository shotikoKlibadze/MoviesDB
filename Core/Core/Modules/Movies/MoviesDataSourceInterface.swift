//
//  MoviesDataSourceInterface.swift
//  Core
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import RxSwift

public protocol MoviesDataSourceInterface {
    func getUpcomingMovies() async throws -> [Movie]
    func getTopRatedMovies() async throws -> [Movie]
    func getNowPlayingMovies() async throws -> [Movie]
}


