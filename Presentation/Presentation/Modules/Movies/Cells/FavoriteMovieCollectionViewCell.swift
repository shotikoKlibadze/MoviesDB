//
//  FavoriteMovieCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.05.22.
//

import UIKit
import Kingfisher
import Core

class FavoriteMovieCollectionViewCell: DBCollectionViewCell {
    
    let imageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.backgroundColor = .red
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.fillSuperview()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with movie: MovieEntity) {
        let imageUrlPref = AppHelper.imagePathPrefix
        if let url = URL(string: imageUrlPref + movie.poster) {
            imageView.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        print ("favorite cell")
//    }
    
    
}
