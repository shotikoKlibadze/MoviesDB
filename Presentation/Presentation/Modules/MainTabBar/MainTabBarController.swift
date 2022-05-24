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
        setupLayout()
        bind()
        view.layoutIfNeeded()
        setupMenuButton()
    }
    
    private func getSelectedViewControllersNavController() {
        if let currentNavController = self.selectedViewController as? UINavigationController {
            self.controller = currentNavController
        }
    }
    


    private func setupMenuButton() {
        view.addSubview(menuButton)
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
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
    }
    
    private func setupLayout() {
        
        customTabBar.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24), size: .init(width: 0, height: 90))
        
//        customTabBar.snp.makeConstraints {
//            $0.leading.trailing.bottom.equalToSuperview().inset(24)
//            $0.height.equalTo(90)
//        }
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        tabBar.isTranslucent = true
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addShadow()
        selectedIndex = 0
    }

    private func selectTabWith(index: Int) {
        if selectedIndex == index {
            (selectedViewController as? UINavigationController)?.popToRootViewController(animated: true)
        } else {
            self.selectedIndex = index
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
