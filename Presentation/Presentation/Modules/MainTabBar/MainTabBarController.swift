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
    
    let menuButton : DBButton = {
        let btn = DBButton(frame: CGRect(x: 20, y: 45, width: 30, height: 30))
       // btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "open", in: Bundle.presentationBundle, with: .none)?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        setupLayout()
        
        bind()
        view.layoutIfNeeded()
        setupMenuButton()
        
        //menuButton.clipsToBounds = true
      //  menuButton.cornerRadius = menuButton.frame.height / 2
        print(menuButton.frame.height)
        
       // menuButton.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        //hidesBottomBarWhenPushed = true

    }
    
    private func getSelectedViewControllersNavController() {
        if let currentNavController = self.selectedViewController as? UINavigationController {
            self.controller = currentNavController
        }
    }
    


    private func setupMenuButton() {
       
        view.addSubview(menuButton)
       // menuButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 45, left: 20, bottom: 0, right: 0), size: .init(width: 30, height: 30))
      //  menuButton.cornerRadius = 15
       // menuButton.layer.masksToBounds = true
        
        
        menuButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        
        
    }
    
    @objc func openSideMenu() {
        guard let baseController = baseController else { return }
        guard baseController.isSideViewOpen else {
            baseController.openMenu()
            return
        }
        baseController.closeMenu()
    }
    
    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent is BaseLayerViewController else {
            return
        }
        baseController = (parent as! BaseLayerViewController)
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

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
       
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        layer.masksToBounds = true
        
    }
}
