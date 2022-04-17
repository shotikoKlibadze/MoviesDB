//
//  MovieDetailsViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.04.22.
//

import UIKit
import Core
import Kingfisher

class MovieDetailsViewController: DBViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        
        
    }
    
    private func configure() {
        tittleLabel.text = movie.title
        descriptionLabel.text = movie.overview
           let imagePathPrefix = AppHelper.imagePathPrefix
        let url = URL(string: imagePathPrefix + movie.backdropPath!)
        posterImageView.kf.setImage(with: url)
    }
    

  

}
