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
    }
    
    enum DataItem : Hashable {
        case nowPlaying(Movie)
        case upcomingMovie(Movie)
        case topRatedMovie(Movie)
    }
    
    private var dataSource : UICollectionViewDiffableDataSource<Sections,DataItem>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        getMovies()
        setupCollectionView()
    }
    
    private func bind() {
        ProgressHUD.show()
        viewModel.getUpcomingMovies()
        viewModel.upcomingMoviesPR.subscribe(onNext: { [weak self] movies in
            self?.upcomingMovies = movies
            DispatchQueue.main.async {
                 self?.updateSnapShot()
                ProgressHUD.dismiss()
            }
           
        }).disposed(by: bag)
        viewModel.moviesErrorPR.subscribe(onNext: { error in
            ProgressHUD.dismiss()
            AppHelper.showAllert(viewController: self, title: "Unexpected Error", message: error.errorMessage)
        }).disposed(by: bag)
    }
    
    private func getMovies(){
        ProgressHUD.show()
        Task {
            do {
                topRatedMovies = try await viewModel.getTopRatedMovies()
                nowPlayingMovies = try await viewModel.getNowPlayingMovies()
                updateSnapShot()
                ProgressHUD.dismiss()
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
        
        
        
    }
    @MainActor
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections,DataItem>()
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(nowPlayingMovies.map({DataItem.nowPlaying($0)}), toSection: .nowPlayingMovies)
        snapShot.appendItems(upcomingMovies.map({DataItem.upcomingMovie($0)}), toSection: .upcomingMovies)
        snapShot.appendItems(topRatedMovies.map({DataItem.topRatedMovie($0)}), toSection: .topRatedMovies)
        dataSource.apply(snapShot)
    }
    



}
