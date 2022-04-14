//
//  HeaderView.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 27.03.22.
//

import Foundation
import UIKit
import Core
import ProgressHUD

class MoviesHeaderView : UICollectionReusableView {
    
    static let identifier = "MoviesHeaderView"
    
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var seeAllBUtton: UIButton!
    
    
    var contextProvider : ContextProvider?
    var controller : MoviesViewController?
    
    @IBAction func seeAllTapped(_ sender: Any) {
        guard let controller = controller, let contextProvider = contextProvider  else {
            return
        }
        let vc = AllMoviesViewController.instantiateFromStoryboard()
        vc.contextProvider = contextProvider
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}
