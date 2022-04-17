//
//  Extension + UIColor.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 14.04.22.
//

import UIKit

extension UIColor {
    
    static func DBGreen() -> UIColor {
        return UIColor(named: "DBgreen",in: Bundle.presentationBundle, compatibleWith: nil)!
    }
    
    static func DBLalebColor() -> UIColor {
        return UIColor(named: "DBLalebColor",in: Bundle.presentationBundle, compatibleWith: nil)!
    }
    
    static func DBTopLayerBackground() -> UIColor {
        return UIColor(named: "DBTopLayerBackground",in: Bundle.presentationBundle, compatibleWith: nil)!
    }
    
}
