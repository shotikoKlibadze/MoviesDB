//
//  FavoriteMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.05.22.
//

import UIKit
import Core
import ProgressHUD

class FavoriteMoviesViewController: DBViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource : UICollectionViewDiffableDataSource<Int,MovieEntity>!
    
    var viewModel : MoviesViewModel!
    var movies = [MovieEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.registerClass(class: FavoriteMovieCollectionViewCell.self)
        collectionView.collectionViewLayout = configureLayout()
        collectionView.dataSource = dataSource
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            let cell = collectionView.deque(FavoriteMovieCollectionViewCell.self, for: indexPath)
            cell?.configure(with: model)
            return cell
        })
    }
    
    private func fetchMovies() {
        ProgressHUD.show()
        Task {
            let movies = await viewModel.getFavoriteMovies()
            self.movies = movies
            print(movies.count)
            configureSnapshot()
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(270)), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,MovieEntity>()
        snapShot.appendSections([0])
        snapShot.appendItems(movies)
        dataSource.apply(snapShot)
        ProgressHUD.dismiss()
    }
}
