//
//  MainTabBarController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import RxSwift
import Core

public class MainTabBarController: UITabBarController {
    
    let moviesViewController = Controller.moviesViewController()
    let tvSeriesVewController = Controller.tvSeriesViewController()
    
    let menuButton : UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 55, width: 30, height: 30))
        btn.setImage(UIImage(named: "open", in: Bundle.presentationBundle, with: .none), for: .normal)
        btn.cornerRadius = 15
        btn.clipsToBounds = true
        return btn
    }()
    
    var baseController : BaseLayerViewController?
    var controller : UINavigationController?

    private let customTabBar = TabBar()
    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
       
        delegate = self
        viewControllers = [
            moviesViewController,
            tvSeriesVewController
        ]
        getSelectedViewControllersNavController()
        ErrorHandler.shared.injectErrorReciever(errorReciever: self)
        
        //tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: "DBBackground")
        view.backgroundColor = UIColor(named: "DBBackground")
        setupProperties()
        setupHierarchy()
       
        bind()
        view.layoutIfNeeded()
        setupMenuButton()
    }
    
    private func getSelectedViewControllersNavController() {
        if let currentNavController = self.selectedViewController as? UINavigationController {
            self.controller = currentNavController
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    private func setupMenuButton() {
        view.addSubview(menuButton)
        menuButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
    }
    
    @objc func openSideMenu() {
        guard let baseController = baseController else { return }
        baseController.isSideViewOpen ?
        baseController.closeMenu() :
        baseController.openMenu()
    }
    
    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent is BaseLayerViewController else {
            return
        }
        baseController = (parent as! BaseLayerViewController)
    }
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
    }
    
    private func setupLayout() {
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        tabBar.isTranslucent = true
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addShadow()
        selectedIndex = 0
    }

    private func selectTabWith(index: Int) {
        self.selectedIndex = index
        if let navController = selectedViewController as? UINavigationController {
            controller = navController
            navController.popToRootViewController(animated: true)
        }
    }

    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in self?.selectTabWith(index: $0) }
            .disposed(by: disposeBag)
    }

}

extension MainTabBarController : ErrorReciever {
    
    public func handleError(error: DBError) {
        AppHelper.showInfoAlert(viewController: self, title: "Error", message: error.errorMessage)
        print(error.debugDescription)
    }
    
}

extension MainTabBarController : UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is UINavigationController {
           controller = viewController as? UINavigationController
        }
    }
}
