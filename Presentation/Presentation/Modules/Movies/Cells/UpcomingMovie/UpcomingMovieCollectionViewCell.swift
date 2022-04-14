//
//  UpcomingMovieCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 26.03.22.
//

import UIKit
import Kingfisher
import Core

class UpcomingMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    func configure(with movie: Movie) {
        let imagePathPrefix = AppHelper.imagePathPrefix
        let url = URL(string: imagePathPrefix + movie.posterPath)
        posterImageView.kf.setImage(with: url)
        tittleLabel.text = movie.title
        ratingsLabel.text = String(movie.voteAverage)
        
    }
    
    func setupUI() {
        containerView.makeCustomRound(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
        containerView.layer.shadowColor = UIColor.red.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: -3)
        containerView.layer.shadowRadius = 30
        containerView.layer.masksToBounds = true
    }

}
