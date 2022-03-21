//
//  MainTabBarController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit

public class MainTabBarController: UITabBarController {
    
    let moviesViewController = Controller.moviesViewController()
    let tvSeriesVewController = Controller.tvSeriesViewController()

    public override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            moviesViewController,
            tvSeriesVewController
        ]
    }

}
