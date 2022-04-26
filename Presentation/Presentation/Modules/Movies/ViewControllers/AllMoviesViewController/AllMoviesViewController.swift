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
    var dataSource : UICollectionViewDiffableDataSource<Int,Movie>!

    var transition = Animator()
    var position = CGRect.zero
    
    
    var sizeViewForTransition = UIView()
    var imageViewForTransition = UIImageView()
    
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
        collectionView.delegate = self
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

extension AllMoviesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let vc = DetailsViewController()
        let vc = MovieDetailsViewController.instantiateFromStoryboard()
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = self
        vc.movie = movies[indexPath.row]
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





