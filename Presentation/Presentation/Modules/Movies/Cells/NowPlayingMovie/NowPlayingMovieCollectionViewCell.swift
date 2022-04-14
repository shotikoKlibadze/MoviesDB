//
//  NowPlayingMovieCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 26.03.22.
//

import UIKit
import Kingfisher
import Core

class NowPlayingMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
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
        ratingLabel.text = String(movie.voteAverage)
    }
    
    func setupUI() {
        containerView.makeCustomRound(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
        containerView.addShadow()
    }
    
}
