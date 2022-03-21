//
//  Controller.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import UIKit


public protocol AppDependencyContainerInterface {
    func getMoviesViewModel() -> MoviesViewModel
    func getTvSeriesViewModel() -> TvSeriesViewModel
}

public class Controller {
    
    public static var appDependencyContainer : AppDependencyContainerInterface?
    
    static func moviesViewController() -> UINavigationController {
        let navController = UINavigationController()
        let vc = MoviesViewController.instantiateFromStoryboard()
        let viewModel = appDependencyContainer?.getMoviesViewModel()
        vc.viewModel = viewModel
        navController.viewControllers = [vc]
        navController.tabBarItem.title = "Moves"
        navController.tabBarItem.image = UIImage(systemName: "film")
        return navController
    }
    
    static func tvSeriesViewController () -> UINavigationController {
        let navController = UINavigationController()
        let vc = TvSeriesViewController.instantiateFromStoryboard()
        let viewModel = appDependencyContainer?.getTvSeriesViewModel()
        vc.viewModel = viewModel
        navController.viewControllers = [vc]
        navController.tabBarItem.title = "TvSeries"
        navController.tabBarItem.image = UIImage(systemName: "tv")
        return navController
    }
}
