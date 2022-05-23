//
//  AllMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import UIKit
import ProgressHUD
import Core
import Kingfisher

class AllMoviesViewController: DBViewController {
    
    var contextProvider : ContextProvider!
    var dataSource : UICollectionViewDiffableDataSource<Int,MovieEntity>!
    var transition = Animator()
    var sizeViewForTransition = UIView()
    var imageViewForTransition = UIImageView()
    var collectionView: UICollectionView?
    
    private var movies = [MovieEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.DBBackgroundColor()
        self.collectionView = collectionView
        view.addSubview(collectionView)
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
                movies = await contextProvider.provideContext()
                updateSnapshot()
            }
        }
    }
    
    private func updateSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,MovieEntity>()
        snapShot.appendSections([0])
        snapShot.appendItems(movies)
        dataSource.apply(snapShot)
        ProgressHUD.dismiss()
    }
}

extension AllMoviesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let vc = DetailsViewController()
        let vc = MovieDetailsViewController.instantiateFromStoryboard()
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = self
        vc.movie = movies[indexPath.row]
        vc.viewModel = contextProvider.viewModel
        vc.delegate = self
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
            let imageView = cell.posterImageView
            sizeViewForTransition = imageView
            imageViewForTransition = imageView
        }
        present(vc, animated: true)
    }
}

extension AllMoviesViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.imageViewForTransition = imageViewForTransition
        transition.sizeViewForTransition = sizeViewForTransition
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

extension AllMoviesViewController : FavoriteMovieStatusChangeDelegate {
    func refresh() {
        getMovies()
    }
}
