//
//  GenreLabelView.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 28.04.22.
//

import UIKit

class GenreLabelView : UIView {
    
    var label : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.textColor = UIColor.DBLalebColor()
        label.numberOfLines = 1
        label.textAlignment = .center
        //label.adjustsFontSizeToFitWidth = true
        //label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        addSubview(label)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 3, left: 8, bottom: 3, right: 8))
    }
    
    
}
