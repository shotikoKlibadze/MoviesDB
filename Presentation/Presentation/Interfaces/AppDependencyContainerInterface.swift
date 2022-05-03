//
//  AppDependencyContainerInterface.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 03.05.22.
//

import Foundation

public protocol AppDependencyContainerInterface {
    func getMoviesViewModel() -> MoviesViewModel
    func getTvSeriesViewModel() -> TvSeriesViewModel
}
