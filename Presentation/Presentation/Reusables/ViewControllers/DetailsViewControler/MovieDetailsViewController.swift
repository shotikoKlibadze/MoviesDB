//
//  MovieDetailsViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.04.22.
//

import UIKit
import Core
import Kingfisher
import ProgressHUD
import Combine

protocol FavoriteMovieStatusChangeDelegate : AnyObject  {
    func refresh()
}

class MovieDetailsViewController: DBViewController {
    
    @IBOutlet weak var overtviewTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var genresStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var movie: MovieEntity!
    var moviesViewModel: MoviesViewModel?
    var tvSeriesViewModel: TvSeriesViewModel?
    var similarMovies = [MovieEntity]()
    var cast = [ActorEntity]()
    var subscribtions = Set<AnyCancellable>()
    
    weak var delegate : FavoriteMovieStatusChangeDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    enum DataItem : Hashable {
        case cast(ActorEntity)
        case similarMovies(MovieEntity)
    }
    
    enum Section : Int, CaseIterable {
        case cast
        case similarMovies
        var sectionHeader : String {
            switch self {
            case .cast:
                return "Cast"
            case .similarMovies:
                return "Similar Movies"
            }
        }
    }
    
    enum SupplementaryElementKind {
        static let sectionHeader = "sectionHeader"
    }
    
    private var dataSource : UICollectionViewDiffableDataSource<Section,DataItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        setUI()
        configureFavoriteButton()
        setupCollectionView()
        overtviewTextView.textContainer.heightTracksTextView = true
        overtviewTextView.isScrollEnabled = false
        getData()
        if let tvSeriesViewModel = tvSeriesViewModel {
            tvSeriesViewModel.getSimilarTvSeries(tvSeriesID: movie.id)
            tvSeriesViewModel.getCastMembers(tvSeriesID: movie.id)
            configureSnapshot()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        if let _ = navigationController {
            closeButton.isHidden = true
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        }
    }
    
    private func getData() {
        ProgressHUD.show()
        guard let moviesViewModel = moviesViewModel else {
            if let tvSeriesViewModel = tvSeriesViewModel {
                tvSeriesViewModel.$similarTvSeries
                    .sink(receiveValue: {[weak self] in self?.similarMovies = $0})
                    .store(in: &subscribtions)
                tvSeriesViewModel.$castMembers
                    .sink(receiveValue: { [weak self] in self?.cast = $0})
                    .store(in: &subscribtions)
            }
            return
        }
        
        Task {
            similarMovies = await moviesViewModel.getSimilarMoives(movieID: movie.id)
            cast = await moviesViewModel.getCastMembers(movieID: movie.id)
            configureSnapshot()
        }
    }
    
    private func setupCollectionView() {
        let layout = MovieDetailsPageLayoutManager().createLayout()
        collectionView.collectionViewLayout = layout
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(CastMemberCollectionViewCell.self, forCellWithReuseIdentifier: CastMemberCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "SeeAllHeaderView", bundle: Bundle.presentationBundle), forSupplementaryViewOfKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, model in
            guard let sectionKind = Section(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }
            switch (sectionKind, model) {
            case (.cast, .cast(let actor)):
                guard let cell = collectionView.deque(CastMemberCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: actor)
                return cell
            case (.similarMovies, .similarMovies(let movie)):
                guard let cell = collectionView.deque(MovieCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
                cell.configure(with: movie, tvSeries: nil, isLargePoster: false)
                return cell
            default :
                return nil
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView , kind , indexPath in
            guard let sectionKind = Section(rawValue: indexPath.section) else {
                fatalError("Unhandled section : \(indexPath.section)")
            }
            if kind == SupplementaryElementKind.sectionHeader {
                switch sectionKind {
                case .cast:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier, for: indexPath) as! SeeAllHeaderView
                    view.seeAllBUtton.isHidden = true
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    return view
                case .similarMovies:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryElementKind.sectionHeader, withReuseIdentifier: SeeAllHeaderView.identifier, for: indexPath) as! SeeAllHeaderView
                    view.seeAllBUtton.isHidden = true
                    view.sectionHeaderLabel.text = sectionKind.sectionHeader
                    return view
                }
            } else {
                return nil
            }
            
        }
    }
    
    @MainActor
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,DataItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(cast.map({DataItem.cast($0)}), toSection: .cast)
        snapshot.appendItems(similarMovies.map({DataItem.similarMovies($0)}), toSection: .similarMovies)
        dataSource.apply(snapshot)
        ProgressHUD.dismiss()
    }
    
    private func configureFavoriteButton() {
        guard movie.isFavorite else {
            favoriteButton.tintColor = .white
            return
        }
        favoriteButton.tintColor = .systemRed
    }
    
    private func setUI() {
        title = movie.tittle
        setupGradientLayer()
        tittleLabel.text = movie.tittle
        overtviewTextView.text = movie.overview
        ratingsLabel.text = String(movie.voteAvarage) + "/10"
        
        let imagePathPrefix = AppHelper.imagePathPrefix
        if let backgroundPoster = movie.wallPaper {
            let url = URL(string: imagePathPrefix + backgroundPoster)
            backgroundPosterImageView.kf.setImage(with: url)
        }
        let posterImage = movie.poster
        let url = URL(string: imagePathPrefix + posterImage)
        posterImageView.kf.setImage(with: url)
        
        for i in movie.genreIDS.indices {
            let labelView = GenreLabelView()
            if let genre = AppHelper.genres[movie.genreIDS[i]] {
                labelView.label.text = genre
                genresStackView.addArrangedSubview(labelView)
            }
        }
    }
    
    
    
    private func setupGradientLayer() {
        gradientView.bringSubviewToFront(posterImageView)
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.darkText.cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0.1, 0.4, 0.7]
        gradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = gradientView.bounds
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard movie.isFavorite else {
            movie.isFavorite = true
            CoreDataManager.shared.save(movie: movie, movieCast: cast)
            delegate?.refresh()
            configureFavoriteButton()
            return
        }
        AppHelper.showActionAlert(viewController: self, title: movie.tittle, message: nil, cancelButtonTittle: "Cancel", actionButtonTitle: "Remove From Favorites", action: removeFromFavorites)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func removeFromFavorites() {
        CoreDataManager.shared.deleteMovie(movie: movie)
        movie.isFavorite = false
        delegate?.refresh()
        configureFavoriteButton()
    }
}
