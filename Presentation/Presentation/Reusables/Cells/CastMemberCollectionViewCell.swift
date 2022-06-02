//
//  CastMemberCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 11.05.22.
//

import Foundation
import UIKit
import Core
import Kingfisher

class CastMemberCollectionViewCell :  UICollectionViewCell {
    
    let posterImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.backgroundColor = .systemGray2
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 30
        return imageview
    }()
    
    let shadowView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60 , height: 60))
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor(named: "DBShadowColor", in: Bundle.presentationBundle, compatibleWith: nil)?.cgColor
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 30).cgPath
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.textColor = UIColor.DBLalebColor()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let characterNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemGray2
        return label
    }()
    
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI() {
        contentView.addSubviews(shadowView, stackView)
        stackView.addArrangedSubviews([nameLabel, characterNameLabel])
        shadowView.addSubview(posterImageView)
        shadowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        shadowView.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil,size: .init(width: 60, height: 60))
        posterImageView.fillSuperview()
        stackView.anchor(top: posterImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
    }
    
    func configure(with actor: ActorEntity) {
        nameLabel.text = actor.name
        characterNameLabel.text = actor.characterPlayed ?? "Unknown"
        let imagePathPrefix = AppHelper.imagePathPrefix
        if let posterURL = actor.profilePic {
            let url = URL(string: imagePathPrefix + posterURL)
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(systemName: "person")!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        shadowView.layer.shadowColor = UIColor(named: "DBShadowColor", in: Bundle.presentationBundle, compatibleWith: nil)?.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
