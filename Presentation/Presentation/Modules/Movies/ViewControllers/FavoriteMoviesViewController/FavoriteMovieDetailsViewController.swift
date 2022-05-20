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
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    let wallpapaerImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
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
    
    let overviewSeparator = SeparatorView()
        
    let overviewSectionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        label.textColor = UIColor.DBLalebColor()
        label.text = "Overview"
        return label
    }()
    
    let overViewStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    let overViewLabel : UILabel = {
        let overViewLabel = UILabel()
        overViewLabel.numberOfLines = 0
        overViewLabel.font = UIFont(name: "Helvetica Neue", size: 13)
        return overViewLabel
    }()
    
    var collectionView : UICollectionView?
    
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
        view.addSubview(scrollView)
        setupHeirarchy()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.width, height: view.height * 1.5)
        setupLayout()
    }
    
    private func  setupHeirarchy() {
        scrollView.addSubviews(wallpapaerImageView, movieTitleLabel, posterImageView, releaseDateLabel, genreStackView, overviewSeparator)
        overviewSeparator.addSubviews(overviewSectionLabel, overViewLabel)
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
        
        wallpapaerImageView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: scrollView.width, height: 200))
        
        movieTitleLabel.sizeToFit()
        let labelSize = movieTitleLabel.sizeThatFits(CGSize(width: scrollView.width, height: scrollView.height))
        movieTitleLabel.anchor(top: wallpapaerImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 10, bottom: 0, right: 0), size: .init(width: scrollView.width, height: labelSize.height))
        
        releaseDateLabel.anchor(top: movieTitleLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor , padding: .init(top: 5, left: 10, bottom: 0, right: 0))
        
        posterImageView.anchor(top: releaseDateLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 30, bottom: 0, right: 0), size: .init(width: 130, height: 190))
        
        genreStackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        genreStackView.anchor(top: nil, leading: posterImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0))
        
        setupMovieOverviewSection()
    }
    
    private func setupMovieOverviewSection() {
        overviewSectionLabel.sizeToFit()
        overViewLabel.sizeToFit()
        
        let overviewLabelSize = overViewLabel.sizeThatFits(.init(width: scrollView.width, height: scrollView.height))
        let overviewSectionLabelSize = overviewSectionLabel.sizeThatFits(.init(width: scrollView.width, height: scrollView.height))
        
        overviewSeparator.anchor(top: posterImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: scrollView.width, height: 0))
        
        overviewSectionLabel.anchor(top: overviewSeparator.topAnchor, leading: overviewSeparator.leadingAnchor, bottom: overViewLabel.topAnchor, trailing: overviewSeparator.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 5, right: 10), size: .init(width: 0, height: overviewSectionLabelSize.height))
        
        overViewLabel.anchor(top: nil, leading: overviewSeparator.leadingAnchor, bottom: overviewSeparator.bottomAnchor, trailing: overviewSeparator.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10), size: .init(width: 0, height: overviewLabelSize.height))
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
