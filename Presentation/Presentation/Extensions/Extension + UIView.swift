//
//  Extension + UIView.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 26.03.22.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func makeCustomRound(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY

            let path = UIBezierPath()
            path.move(to: CGPoint(x: minX + topLeft, y: minY))
            path.addLine(to: CGPoint(x: maxX - topRight, y: minY))
            path.addArc(withCenter: CGPoint(x: maxX - topRight, y: minY + topRight), radius: topRight, startAngle:CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: maxX, y: maxY - bottomRight))
            path.addArc(withCenter: CGPoint(x: maxX - bottomRight, y: maxY - bottomRight), radius: bottomRight, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
            path.addLine(to: CGPoint(x: minX + bottomLeft, y: maxY))
            path.addArc(withCenter: CGPoint(x: minX + bottomLeft, y: maxY - bottomLeft), radius: bottomLeft, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            path.addLine(to: CGPoint(x: minX, y: minY + topLeft))
            path.addArc(withCenter: CGPoint(x: minX + topLeft, y: minY + topLeft), radius: topLeft, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
            path.close()

            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
}
