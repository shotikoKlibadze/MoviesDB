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

    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with movie: Movie) {
        let imagePathPrefix = AppHelper.imagePathPrefix
        let url = URL(string: imagePathPrefix + movie.posterPath)
        posterImageView.kf.setImage(with: url)
    }

}
