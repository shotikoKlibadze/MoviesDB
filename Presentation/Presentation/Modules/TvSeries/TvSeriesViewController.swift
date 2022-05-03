//
//  TvSeriesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit

public class TvSeriesViewController: DBViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: TvSeriesViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
      title = "TV Series"
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard (navigationController?.viewControllers.count)! > 1 else { return }
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = true
    }
    
  

    
}
