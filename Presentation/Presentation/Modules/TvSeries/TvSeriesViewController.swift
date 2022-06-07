//
//  TvSeriesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import Core
import Combine

public class TvSeriesViewController: DBViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onAirTvSeries = [MovieEntity]()
    var popularTvSeries = [MovieEntity]()
    var topRatedTvSeries = [MovieEntity]()
    
    enum SectionKind: Int, CaseIterable {
        case onAir
        case popular
        case topRated
        
        var sectionHeader : String {
            switch self {
            case .onAir:
                return "Tv Series On Air Now"
            case .popular:
                return "Popular Tv Series"
            case .topRated:
                return "Top Rated Tv Series"
            }
        }
    }
    
    enum DataItem: Hashable  {
        case onAir(MovieEntity)
        case popular(MovieEntity)
        case topRated(MovieEntity)
    }
    
    enum SupplementaryElementKind {
        static let sectionHeader = "sectionHeader"
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionKind,DataItem>!
    
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TvSeriesViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Series"
       // navigationController?.navigationBar.backgroundColor = UIColor.DBBackgroundColor()
        setupCollectionView()
        viewModel.getData()
        bind()
        viewModel.getCastMembers(tvSeriesID: 66732)
        viewModel.getSimilarTvSeries(tvSeriesID: 66732)
        
       
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = TvSeriesDashbboardPageLaoutManager().createLayout()
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.DBBackgroundColor()
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        //Cell Registration
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        //View Registration
        collectionView.register(UINib(nibName: "SeeAllHeaderView", bundle: Bundle.presentationBundle), forSupplementaryViewOfKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier)
        
        //DataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let sectionKind = SectionKind(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }
            switch (sectionKind, model) {
            case (.onAir, .onAir(let tvSeries)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: nil, tvSeries: tvSeries, isLargePoster: true)
                return cell
            case (.popular, .popular(let tvSeries)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: nil, tvSeries: tvSeries, isLargePoster: false)
                return cell
            case (.topRated, .topRated(let tvSeries)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: nil, tvSeries: tvSeries, isLargePoster: false)
                return cell
            default :
                return nil
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView , kind , indexPath in
            guard let sectionKind = SectionKind(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }

            if kind == SupplementaryElementKind.sectionHeader {
                switch sectionKind {
                case .onAir:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier, for: indexPath) as! SeeAllHeaderView
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    view.sectionHeaderLabel.textAlignment = .center
                    view.sectionHeaderLabel.font = UIFont.init(name: "Helvetica Neue Bold", size: 20)
                    view.redView.isHidden = true
                    view.seeAllBUtton.isHidden = true
                    return view
                case .popular:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier, for: indexPath) as! SeeAllHeaderView
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    let contextProvider = PopularTvSeriesProvider()
                    contextProvider.viewModel = self.viewModel
                    view.tvSeriesController = self
                    view.tvContextProvider = contextProvider
                    return view
                case .topRated:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier, for: indexPath) as! SeeAllHeaderView
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    view.seeAllBUtton.isHidden = false
                    view.redView.isHidden = false
                    view.sectionHeaderLabel.textAlignment = .left
                    view.sectionHeaderLabel.font = UIFont.init(name: "Helvetica Neue Bold", size: 17)
                    let contextProvider = TopRatedTvSeriesProvider()
                    contextProvider.viewModel = self.viewModel
                    view.tvSeriesController = self
                    view.tvContextProvider = contextProvider
                    return view
                }
            } else {
                return nil
            }
        }
    }
    
    private func bind() {
        viewModel.$onAirTvSeries
            .sink(receiveValue: { [weak self] in
                self?.onAirTvSeries = $0
                self?.updateSnapshot()
            })
            .store(in: &subscriptions)
        viewModel.$topRatedTvSeries
            .sink(receiveValue: {[weak self] in
                self?.topRatedTvSeries = $0
                self?.updateSnapshot()
            })
            .store(in: &subscriptions)
        viewModel.$popularTvSeries
            .sink(receiveValue: {[weak self] in
                self?.popularTvSeries = $0
                self?.updateSnapshot()
            })
            .store(in: &subscriptions)
    }
    
    func updateSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<SectionKind,DataItem>()
        snapShot.appendSections(SectionKind.allCases)
        snapShot.appendItems(onAirTvSeries.map({DataItem.onAir($0)}), toSection: .onAir)
        snapShot.appendItems(popularTvSeries.map({DataItem.popular($0)}), toSection: .popular)
        snapShot.appendItems(topRatedTvSeries.map({DataItem.topRated($0)}), toSection: .topRated)
        dataSource.apply(snapShot)
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

}

extension TvSeriesViewController : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tvSerie: MovieEntity?
        let sections = SectionKind(rawValue: indexPath.section)
        switch sections {
        case .onAir:
            tvSerie = onAirTvSeries[indexPath.row]
        case .popular:
            tvSerie = popularTvSeries[indexPath.row]
        case .topRated:
            tvSerie = topRatedTvSeries[indexPath.row]
        case .none:
            break
        }
        let vc = MovieDetailsViewController.instantiateFromStoryboard()
        vc.movie = tvSerie
        vc.tvSeriesViewModel = viewModel
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TvSeriesViewController : FavoriteMovieStatusChangeDelegate {
    func refresh() {
        
    }
}
