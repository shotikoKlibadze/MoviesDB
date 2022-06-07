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

class SeeAllHeaderView : UICollectionReusableView {
    
    static let identifier = "SeeAllHeaderView"
    
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var seeAllBUtton: UIButton!
    
    var movieContextProvider : MovieContextProvider?
    var tvContextProvider : TvSeriesContextProvider?
    var moviesController : MoviesViewController?
    var tvSeriesController: TvSeriesViewController?
    
    @IBAction func seeAllTapped(_ sender: Any) {
        guard let moviesController = moviesController, let moviesContextProvider = movieContextProvider  else {
            
            if let tvSeriesController = tvSeriesController, let tvContextProvider = tvContextProvider {
                let vc = AllTvSeriesViewController()
                vc.contextProvider = tvContextProvider
                tvSeriesController.navigationController?.pushViewController(vc, animated: true)
            }
            
            return
        }
        let vc = AllMoviesViewController()
        vc.contextProvider = moviesContextProvider
        moviesController.navigationController?.pushViewController(vc, animated: true)
    }
}
