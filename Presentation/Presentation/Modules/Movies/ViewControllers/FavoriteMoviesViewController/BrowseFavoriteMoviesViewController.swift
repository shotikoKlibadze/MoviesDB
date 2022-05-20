//
//  BrowseFavoriteMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 18.05.22.
//

import UIKit
import Core

class BrowseFavoriteMoviesViewController: UIViewController {
    
    var movies = [MovieEntity]()
    var movie : MovieEntity!
    
    lazy var dismisButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        return btn
    }()
    
    let pagingViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.DBBackgroundColor()
        setupPagingViewController()
        view.addSubview(dismisButton)
        dismisButton.frame = CGRect(x: 24, y: 50, width: 25, height: 25)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    private func setupPagingViewController() {
        let vc = FavoriteMovieDetailsViewController(with: movie)
        pagingViewController.setViewControllers([vc], direction: .forward, animated: false)
        pagingViewController.dataSource = self
        view.addSubview(pagingViewController.view)
        
        pagingViewController.view.fillSuperview(padding: .init(top: view.safeAreaInsets.top + 80, left: 24, bottom: view.safeAreaInsets.bottom + 70, right: 24))
        pagingViewController.view.layer.cornerRadius = 10
    }
    
}

extension BrowseFavoriteMoviesViewController : UIPageViewControllerDataSource {
    
    //Function that returns previous post
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentMovie = (viewController as? FavoriteMovieDetailsViewController)?.movie else {
            return nil
        }
        guard let index = movies.firstIndex(where: { movie in
            movie.id == currentMovie.id
        }) else { return nil }
        
        if index == 0 { return nil }
        
        let previousIndex = index - 1
        let movie = movies[previousIndex]
        let vc = FavoriteMovieDetailsViewController(with: movie)
        return vc
    }
    
    //Function that returns next post
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentMovie = (viewController as? FavoriteMovieDetailsViewController)?.movie else {
            return nil
        }
        guard let index = movies.firstIndex(where: { movie in
            movie.id == currentMovie.id
        }) else { return nil }
        
        guard index < (movies.count - 1) else { return nil }
        
        let previousIndex = index + 1
        let movie = movies[previousIndex]
        let vc = FavoriteMovieDetailsViewController(with: movie)
        return vc
    }
    
    
}
