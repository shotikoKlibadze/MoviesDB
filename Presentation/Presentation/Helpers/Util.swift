//
//  Utils.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation
import UIKit

public class Util {
    
    static func showAllert(viewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            allertController.addAction(okAction)
            viewController.present(allertController, animated: true)
        }
    }
    
}
