//
//  FavoriteMovieTableViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 20.06.22.
//

import UIKit
import Core
import Kingfisher

class FavoriteMovieTableViewCell: UITableViewCell {
    
    static let identifier = "FavoriteMovieTableViewCell"

    private let posterImageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        posterImageView.layer.cornerRadius = 10
    }
    
    func configure(with movie: MovieEntity) {
        guard let posterURL = movie.wallPaper else { return }
        let urlPrefix = AppHelper.imagePathPrefix
        if let url = URL(string: urlPrefix + posterURL) {
            posterImageView.kf.setImage(with: url)
        }
    }
    
}
