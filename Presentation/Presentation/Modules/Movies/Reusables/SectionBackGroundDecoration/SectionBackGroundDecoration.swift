//
//  SectionBackGroundDecoration.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 27.03.22.
//

import Foundation
import UIKit

class SectionBackGroundDecoration : UICollectionReusableView {
    
    static let identifier = "SectionBackGroundDecoration"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = UIColor(named: "DBSecondaryBackGround", in: Bundle.presentationBundle, compatibleWith: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
