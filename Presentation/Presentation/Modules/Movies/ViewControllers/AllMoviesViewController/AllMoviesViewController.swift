//
//  AllMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import UIKit
import ProgressHUD
import Core

class AllMoviesViewController: DBViewController {
    
    var contextProvider : ContextProvider!
    var dataSource : UICollectionViewDiffableDataSource<Int,Movie>!
    
    private var movies = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getMovies()
    }

    private func setupCollectionView() {
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource
        view.layoutSubviews()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError() }
            cell.configure(with: model, isLargePoster: true)
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func getMovies() {
        ProgressHUD.show()
        Task {
            do {
                movies = try await contextProvider.provideContext()
                updateSnapshot()
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,Movie>()
        snapShot.appendSections([0])
        snapShot.appendItems(movies)
        dataSource.apply(snapShot)
        ProgressHUD.dismiss()
    }
}
