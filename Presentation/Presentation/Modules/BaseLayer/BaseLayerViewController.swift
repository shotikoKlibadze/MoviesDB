//
//  BaseLayerViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 02.05.22.
//

import UIKit

public class BaseLayerViewController: UIViewController {
    
    var mainViewLeadingConstraint: NSLayoutConstraint!
    var mainViewTrailingConstraint: NSLayoutConstraint!
    var mainController : MainTabBarController!
    var sideViewWidth : CGFloat = 250
    var isSideViewOpen = false
    
    let mainView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let sideView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let darkCoverView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseViews()
        setupControllers()
        setupTapgesture()
    }
    
    private func setupTapgesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    func openMenu() {
        isSideViewOpen = true
        mainViewLeadingConstraint.constant = sideViewWidth
        mainViewTrailingConstraint.constant = sideViewWidth
        performAnimations()
    }
    
    @objc func closeMenu() {
        isSideViewOpen = false
        mainViewLeadingConstraint.constant = 0
        mainViewTrailingConstraint.constant = 0
        performAnimations()
    }
    
    private func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isSideViewOpen ? 1 : 0
        })
    }
    
    private func setupBaseViews() {
        view.addSubviews(sideView, mainView)
    
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sideView.topAnchor.constraint(equalTo: view.topAnchor),
            sideView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sideView.widthAnchor.constraint(equalToConstant: sideViewWidth)
        ])
        
        mainViewLeadingConstraint = mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        mainViewTrailingConstraint = mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        mainViewLeadingConstraint.isActive = true
        mainViewTrailingConstraint.isActive = true
    }
    
    private func setupControllers() {
        mainController = MainTabBarController()
        let mainControllerView = mainController.view!
        mainView.addSubview(mainControllerView)
        mainView.addSubview(darkCoverView)
        darkCoverView.fillSuperview()
        mainControllerView.fillSuperview()
        mainController.didMove(toParent: self)
        
        let profileVC = ProfileViewController()
        profileVC.tabBar = mainController
        let profileView = profileVC.view!
        sideView.addSubview(profileView)
        profileView.fillSuperview()
        addChild(profileVC)
        profileVC.didMove(toParent: self)
        
    }
}
