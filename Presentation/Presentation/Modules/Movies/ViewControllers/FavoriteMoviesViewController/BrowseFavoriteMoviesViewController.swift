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
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .gray
        btn.frame = CGRect(x: 16, y: 50, width: 15, height: 15)
        return btn
    }()
    
    let pagingViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.DBBackgroundColor()
        setupPagingViewController()
        view.addSubview(dismisButton)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    private func setupPagingViewController() {
        let vc = FavoriteMovieDetailsViewController(with: movie)
        pagingViewController.setViewControllers([vc], direction: .forward, animated: false)
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        view.addSubview(pagingViewController.view)
        pagingViewController.view.fillSuperview(padding: .init(top: view.safeAreaInsets.top + 70, left: 24, bottom: view.safeAreaInsets.bottom + 80, right: 24))
        pagingViewController.view.layer.cornerRadius = 10
   
    }
}

extension BrowseFavoriteMoviesViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //Function that returns previous post
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentMovie = (viewController as? FavoriteMovieDetailsViewController)?.movie else {
            return nil
        }
        guard let index = movies.firstIndex(where: { movie in
            movie.id == currentMovie.id
        }) else { return nil }
        
        if index == 0 {
            return nil
        }
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
        
        guard index < (movies.count - 1) else {
            return nil
        }
        let nextIndext = index + 1
        let movie = movies[nextIndext]
        let vc = FavoriteMovieDetailsViewController(with: movie)
        return vc
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return movies.firstIndex(of: movie) ?? 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return movies.count
    }
    

    
}
