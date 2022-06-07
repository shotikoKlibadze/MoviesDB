//
//  AllTvSeriesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation

import UIKit
import ProgressHUD
import Core
import Kingfisher
import Combine

class AllTvSeriesViewController: DBViewController {
    
    var contextProvider : TvSeriesContextProvider!
    var dataSource : UICollectionViewDiffableDataSource<Int,MovieEntity>!
    var transition = Animator()
    var sizeViewForTransition = UIView()
    var imageViewForTransition = UIImageView()
    var collectionView: UICollectionView?
    private var subscriptions = Set<AnyCancellable>()
    private var tvSeries = [MovieEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contextProvider?.provideContext()
        setupCollectionView()
        bind()
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contextProvider?.resetContext()
    }

    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.DBBackgroundColor()
        self.collectionView = collectionView
        view.addSubview(collectionView)
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, model in
            guard let self = self else { fatalError() }
            if self.tvSeries.count - 1 == indexPath.row {
                self.contextProvider.provideMoreContext()
            }
            guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError() }
            cell.configure(with: nil, tvSeries: model, isLargePoster: true)
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
    
    private func bind() {
        guard let contextProvider = contextProvider as? TopRatedTvSeriesProvider else {
            if let anotherContext = self.contextProvider as? PopularTvSeriesProvider {
                anotherContext.$popularTvSeries
                    .sink(receiveValue: { [weak self] in
                        self?.tvSeries = $0
                        self?.updateSnapshot()
                    })
                    .store(in: &subscriptions)
            }
            return
        }
        
        contextProvider.$topRatedTvSeries
            .sink(receiveValue: { [weak self] in
                self?.tvSeries = $0
                self?.updateSnapshot()
            })
            .store(in: &subscriptions)
    }
    
    private func updateSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,MovieEntity>()
        snapShot.appendSections([0])
        snapShot.appendItems(tvSeries)
        dataSource.apply(snapShot)
        ProgressHUD.dismiss()
    }
    
}

extension AllTvSeriesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController.instantiateFromStoryboard()
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = self
        vc.movie = tvSeries[indexPath.row]
        guard let contextsProvider = contextProvider else { return }
        vc.tvSeriesViewModel = contextsProvider.viewModel
        vc.delegate = self
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
            let imageView = cell.posterImageView
            sizeViewForTransition = imageView
            imageViewForTransition = imageView
        }
        present(vc, animated: true)
    }
}

extension AllTvSeriesViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.imageViewForTransition = imageViewForTransition
        transition.sizeViewForTransition = sizeViewForTransition
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

extension AllTvSeriesViewController : FavoriteMovieStatusChangeDelegate {
    func refresh() {
        
    }
}
