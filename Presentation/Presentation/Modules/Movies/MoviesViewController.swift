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

extension UIColor {
    static func soposGreen() -> UIColor {
        return UIColor(named: "DBgreen",in: Bundle.presentationBundle, compatibleWith: nil)!
    }
}

public class MoviesViewController: MDBViewController {
    
    let bag = DisposeBag()
    var viewModel: MoviesViewModel!
    
    var upcomingMovies = [Movie]()
    var topRatedMovies = [Movie]()
    var nowPlayingMovies = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        case nowPlaying(Movie)
        case upcomingMovie(Movie)
        case topRatedMovie(Movie)
    }
    
    enum SupplementaryElementKind {
        static let sectionHeader = "sectionHeader"
    }
    
    private var dataSource : UICollectionViewDiffableDataSource<Sections,DataItem>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        setupCollectionView()
        collectionView.backgroundColor = .clear
        view.backgroundColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.soposGreen()]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .black
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        title = "Movies"
        
    }
    
    
    private func getMovies(){
        ProgressHUD.show()
        Task {
            do {
                nowPlayingMovies = try await viewModel.getNowPlayingMovies()
                upcomingMovies = try await viewModel.getUpcomingMovies()
                topRatedMovies = try await viewModel.getTopRatedMovies()
                updateSnapShot()
               // ProgressHUD.dismiss()
            } catch (let error) {
                guard let error = error as? DBError else {return}
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        //Layout
        let layOut = LaoOutManager().createLayout()
        collectionView.collectionViewLayout = layOut
        //Cell Registration
        collectionView.registerNib(class: UpcomingMovieCollectionViewCell.self)
        collectionView.registerNib(class: TopRatedMovieCollectionViewCell.self)
        collectionView.registerNib(class: NowPlayingMovieCollectionViewCell.self)
        //View Registration
        collectionView.register(UINib(nibName: "MoviesHeaderView", bundle: Bundle.presentationBundle), forSupplementaryViewOfKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: MoviesHeaderView.identifier)
        
        //DataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let sectionKind = Sections(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }
            switch (sectionKind, model) {
                
            case (.nowPlayingMovies, .nowPlaying(let movie)):
                guard let cell = collectionView.deque(NowPlayingMovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie)
                return cell
            case (.upcomingMovies, .upcomingMovie(let movie)):
                guard let cell = collectionView.deque(UpcomingMovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie)
                return cell
            case (.topRatedMovies, .topRatedMovie(let movie)):
                guard let cell = collectionView.deque(TopRatedMovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie)
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
