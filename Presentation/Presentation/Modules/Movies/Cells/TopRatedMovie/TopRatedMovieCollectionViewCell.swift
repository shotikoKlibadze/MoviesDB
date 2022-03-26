//
//  TopRatedMovieCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 26.03.22.
//

import UIKit
import Kingfisher
import Core

class TopRatedMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    }

}
