//
//  FavoriteMovieDetailsViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 18.05.22.
//

import UIKit
import Core
import Kingfisher

class FavoriteMovieDetailsViewController: UIViewController {
    
    let movie : MovieEntity
    var separator1 = UIView()
    var separator2 = UIView()
    
    //CollectionView
    var collectionView : UICollectionView?
    
    var dataSource : UICollectionViewDiffableDataSource<Int,ActorEntity>!
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    let contentView : UIView = {
        let view = UIView()
        return view
    }()
    
    let wallpapaerImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        imgv.backgroundColor = .red
        return imgv
    }()
    
    let movieTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium", size: 24)
        label.textColor = UIColor.DBLalebColor()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let posterImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.clipsToBounds = true
        imgv.layer.cornerRadius = 10
        return imgv
    }()
    
    let genreStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    let overviewSectionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        label.textColor = UIColor.DBLalebColor()
        label.text = "Overview"
        return label
    }()
    
    let overViewLabel : UILabel = {
        let overViewLabel = UILabel()
        overViewLabel.numberOfLines = 0
        overViewLabel.sizeToFit()
        overViewLabel.font = UIFont(name: "Helvetica Neue", size: 13)
        return overViewLabel
    }()
    
    let castSectionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        label.textColor = UIColor.DBLalebColor()
        label.text = "Cast"
        label.sizeToFit()
        return label
    }()
    
   
    
    init(with movie: MovieEntity) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.DBTopLayerBackground()
        setupHeirarchy()
        setupScrollView()
        setupUI()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
        
    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.dataSource = dataSource
        collectionView.registerClass(class: CastMemberCollectionViewCell.self)
        contentView.addSubview(collectionView)
        self.collectionView = collectionView
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, model in
            guard let cell = collectionView.deque(CastMemberCollectionViewCell.self, for: indexPath) else { fatalError("Cell Can't Be Found") }
            cell.configure(with: model)
            return cell
        })
        snapshot()
        
    }
    
    private func snapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,ActorEntity>()
        snapShot.appendSections([0])
        guard let cast = movie.cast else { return }
        snapShot.appendItems(cast)
        dataSource.apply(snapShot)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 1500).isActive = true
    }
    
    private func  setupHeirarchy() {
        contentView.addSubview(wallpapaerImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreStackView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(separator1)
        contentView.addSubview(overviewSectionLabel)
        contentView.addSubview(overViewLabel)
        contentView.addSubview(separator2)
        contentView.addSubview(castSectionLabel)
    }
    
    private func setupUI() {
        let urlPrefix = AppHelper.imagePathPrefix
        //ImageViews
        if let imageURL = movie.wallPaper {
            let url = URL(string: urlPrefix + imageURL)
            wallpapaerImageView.kf.setImage(with: url)
        }
        let posterImgURL = movie.poster
        let url = URL(string: urlPrefix + posterImgURL)
        posterImageView.kf.setImage(with: url)

        //Labels
        movieTitleLabel.text = movie.tittle
        if let date = dateString(date: movie.releaseDate) {
            releaseDateLabel.text = date
        }

        //GenreLabels
        for i in movie.genreIDS.indices {
            let labelView = GenreLabelView()
            if let genre = AppHelper.genres[movie.genreIDS[i]] {
                labelView.label.text = genre
                genreStackView.addArrangedSubview(labelView)
            }
        }

        //OverView
        overViewLabel.text = movie.overview
    }
    
    private func setupLayout() {
        
        wallpapaerImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: .init(width: 0, height: 200))
        
        movieTitleLabel.sizeToFit()
        let labelSize = movieTitleLabel.sizeThatFits(CGSize(width: scrollView.width, height: scrollView.height))
        movieTitleLabel.anchor(top: wallpapaerImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 0), size: .init(width: 0, height: labelSize.height))
        
        releaseDateLabel.anchor(top: movieTitleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor , padding: .init(top: 5, left: 10, bottom: 0, right: 0))

        posterImageView.anchor(top: releaseDateLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 30, bottom: 0, right: 0), size: .init(width: 130, height: 190))

        genreStackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        genreStackView.anchor(top: nil, leading: posterImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0))

        //OverView Section
        separator1.anchor(top: posterImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.3))
        separator1.backgroundColor = .lightGray

        overviewSectionLabel.anchor(top: separator1.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        overViewLabel.sizeToFit()
        let overviewLabelSize = overViewLabel.sizeThatFits(.init(width: scrollView.width, height: scrollView.height))
        overViewLabel.anchor(top: overviewSectionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: overviewLabelSize.height))
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.anchor(top: overViewLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 13, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.3))
        separator2.backgroundColor = .lightGray
        
        castSectionLabel.anchor(top: separator2.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 20, right: 0))
        
        collectionView?.anchor(top: castSectionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 20, right: 0), size: .init(width: 0, height: 180))
    }

    private func dateString(date: String) -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        guard let date = isoDateFormatter.date(from: date) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, y"
        formatter.locale = Locale(identifier: "en")
        let stringToReturn = formatter.string(from: date)
        return stringToReturn
    }
}

extension FavoriteMovieDetailsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        guard offset < 0 else { return }
        wallpapaerImageView.transform = CGAffineTransform(translationX: 0, y: offset)
    }
}

extension FavoriteMovieDetailsViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
