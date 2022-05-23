//
//  MoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import Core
import ProgressHUD
import RxSwift

public class MoviesViewController: DBViewController {
   
    let bag = DisposeBag()
    var viewModel: MoviesViewModel!
    
    var upcomingMovies = [MovieEntity]()
    var topRatedMovies = [MovieEntity]()
    var nowPlayingMovies = [MovieEntity]()
    
    var collectionView : UICollectionView?
    
    enum Sections : Int, CaseIterable {
        case nowPlayingMovies
        case upcomingMovies
        case topRatedMovies
        var sectionHeader : String {
            switch self {
            case .nowPlayingMovies:
                return "Now Playing In Cinemas"
            case .upcomingMovies:
                return "Upcoming "
            case .topRatedMovies:
                return "Top Rated "
            }
        }
    }
    
    enum DataItem : Hashable {
        case nowPlaying(MovieEntity)
        case upcomingMovie(MovieEntity)
        case topRatedMovie(MovieEntity)
    }
    
    enum SupplementaryElementKind {
        static let sectionHeader = "sectionHeader"
    }
    
    private var dataSource : UICollectionViewDiffableDataSource<Sections,DataItem>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovies()
        setupCollectionView()
        title = "Movies"
    }
    
    public override func viewDidLayoutSubviews() {
        collectionView?.fillSuperview()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard (navigationController?.viewControllers.count)! > 1 else { return }
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = true
    }
    
    private func getMovies(){
        ProgressHUD.show()
        Task {
            do {
                nowPlayingMovies = await viewModel.getNowPlayingMovies()
                upcomingMovies = await viewModel.getUpcomingMovies()
                topRatedMovies = await viewModel.getTopRatedMovies()
                updateSnapShot()
            }
        }
    }
    
    private func setupCollectionView() {
        //Layout
        let layOut = MoviesDashboardPageLaoOutManager().createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layOut)
        collectionView.collectionViewLayout = layOut
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.DBBackgroundColor()
        view.addSubview(collectionView)
        self.collectionView = collectionView
        //Cell Registration
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        //View Registration
        collectionView.register(UINib(nibName: "MoviesHeaderView", bundle: Bundle.presentationBundle), forSupplementaryViewOfKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: MoviesHeaderView.identifier)
        
        //DataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let sectionKind = Sections(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }
            switch (sectionKind, model) {
            case (.nowPlayingMovies, .nowPlaying(let movie)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie, isLargePoster: false)
                return cell
            case (.upcomingMovies, .upcomingMovie(let movie)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie, isLargePoster: false)
                return cell
            case (.topRatedMovies, .topRatedMovie(let movie)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie, isLargePoster: false)
                return cell
            default :
                return nil
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView , kind , indexPath in
            guard let sectionKind = Sections(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }

            if kind == SupplementaryElementKind.sectionHeader {
                switch sectionKind {
                case .nowPlayingMovies:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: MoviesHeaderView.identifier, for: indexPath) as! MoviesHeaderView
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    view.sectionHeaderLabel.textAlignment = .center
                    view.sectionHeaderLabel.font = UIFont.init(name: "Helvetica Neue Bold", size: 20)
                    view.redView.isHidden = true
                    view.seeAllBUtton.isHidden = true
                    return view
                case .upcomingMovies:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: MoviesHeaderView.identifier, for: indexPath) as! MoviesHeaderView
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    let contextProvider = UpcomingMoviesProvider()
                    contextProvider.viewModel = self.viewModel
                    view.controller = self
                    view.contextProvider = contextProvider
                    return view
                case .topRatedMovies:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: MoviesHeaderView.identifier, for: indexPath) as! MoviesHeaderView
                    let contextProvider = TopRatedMoviesProvider()
                    contextProvider.viewModel = self.viewModel
                    view.controller = self
                    view.contextProvider = contextProvider
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    return view
                }
            } else {
                return nil
            }
        }
    }
    
    @MainActor
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections,DataItem>()
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(nowPlayingMovies.map({DataItem.nowPlaying($0)}), toSection: .nowPlayingMovies)
        snapShot.appendItems(upcomingMovies.map({DataItem.upcomingMovie($0)}), toSection: .upcomingMovies)
        snapShot.appendItems(topRatedMovies.map({DataItem.topRatedMovie($0)}), toSection: .topRatedMovies)
        dataSource.apply(snapShot)
        ProgressHUD.dismiss()
    }
}

extension MoviesViewController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie : MovieEntity?
        let section = Sections(rawValue: indexPath.section)
        switch section {
        case .nowPlayingMovies:
            movie = nowPlayingMovies[indexPath.row]
        case .upcomingMovies:
            movie = upcomingMovies[indexPath.row]
        case .topRatedMovies:
            movie = topRatedMovies[indexPath.row]
        case .none:
            return
        }
        
        let vc = MovieDetailsViewController.instantiateFromStoryboard()
        vc.movie = movie
        vc.viewModel = viewModel
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MoviesViewController : FavoriteMovieStatusChangeDelegate {
    func refresh() {
        getMovies()
    }
}

