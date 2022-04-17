//
//  DBCollectionViewCell.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.04.22.
//

import Foundation
import UIKit

class DBCollectionViewCell : UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor(named: "DBShadowColor", in: Bundle.presentationBundle, compatibleWith: nil)?.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor(named: "DBShadowColor", in: Bundle.presentationBundle, compatibleWith: nil)?.cgColor
    }
    
}
