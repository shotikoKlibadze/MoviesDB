//
//  MainTabBarController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import RxSwift


public class MainTabBarController: UITabBarController {
    
    let moviesViewController = Controller.moviesViewController()
    let tvSeriesVewController = Controller.tvSeriesViewController()
    
    private let customTabBar = TabBar()
    
    
    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            moviesViewController,
            tvSeriesVewController
        ]
        tabBar.isTranslucent = false
        tabBar.barTintColor  = .black
        setupProperties()
        setupHierarchy()
        setupLayout()
        
        bind()
        view.layoutIfNeeded()
    }
    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = true
//    }
    
    private func setupHierarchy() {
        //view.addSubview(customTabBar)
    }
    
    private func setupLayout() {
//        customTabBar.backgroundColor = .red
//        customTabBar.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
//            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
//            customTabBar.heightAnchor.constraint(equalToConstant: 90)
//        ])
//
    }
    
    private func setupProperties() {
       // tabBar.isHidden = true
        //tabBar.isTranslucent = true
       // customTabBar.translatesAutoresizingMaskIntoConstraints = false
      //  customTabBar.addShadow()
      //  selectedIndex = 0
    }

    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }

    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in self?.selectTabWith(index: $0) }
            .disposed(by: disposeBag)
    }

}
