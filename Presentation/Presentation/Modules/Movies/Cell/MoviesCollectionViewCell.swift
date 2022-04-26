//
//  MoviesCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 17.04.22.
//

import UIKit
import Core
import Kingfisher

class MovieCollectionViewCell : DBCollectionViewCell {
    
    let posterImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    let titleView : UIView = {
        let titleview = UIView()
        return titleview
    }()

    let starImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(named: "Star", in: Bundle.presentationBundle, with: nil)
        return imageview
    }()

    let ratingsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .systemGray2
        return label
    }()

    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    let titleLable : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.textColor = UIColor.DBLalebColor()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setUI()
        contentView.backgroundColor = .yellow
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(posterImageView, titleView)
        titleView.addSubviews(stackView, titleLable)
        stackView.addArrangedSubviews([starImageView, ratingsLabel])
    }
    
    private func setupLayout() {
        posterImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: titleView.topAnchor, trailing: contentView.trailingAnchor)
        titleView.anchor(top: posterImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, size: .init(width: 0, height: 50))
        stackView.anchor(top: titleView.topAnchor, leading: titleView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 10, bottom: 0, right: 0))
        starImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 15, height: 15))
        titleLable.anchor(top: stackView.bottomAnchor, leading: titleView.leadingAnchor, bottom: nil, trailing: titleView.trailingAnchor, padding: UIEdgeInsets.init(top: 4, left: 10, bottom: 0, right: 10))
    }
    
    private func setUI() {
        titleView.backgroundColor = UIColor.DBTopLayerBackground()
        //contentView.layer.cornerRadius = 8
        contentView.makeCustomRound(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
    }
    
    func configure(with movie: Movie, isLargePoster: Bool) {
        titleLable.text = movie.originalTitle
        ratingsLabel.text = String(movie.voteAverage)
        let imagePathPrefix = AppHelper.imagePathPrefix
        if isLargePoster {
            if let largePoster = movie.backdropPath {
                let url = URL(string: imagePathPrefix + largePoster)
                posterImageView.kf.setImage(with: url)
            }
        } else {
            let url = URL(string: imagePathPrefix + movie.posterPath)
            posterImageView.kf.setImage(with: url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
