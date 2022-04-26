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
       // print("will appear", posterImageView.frame)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("appeard", posterImageView.frame)
    }
    
    private func configure() {
        tittleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        let imagePathPrefix = AppHelper.imagePathPrefix
        if let largePoster = movie.backdropPath {
            let url = URL(string: imagePathPrefix + largePoster)
            posterImageView.kf.setImage(with: url)
        }
        
        print("when not appeard,",posterImageView.frame)
        
    }
    

    @IBAction func dismiss(_ sender: Any) {
        print(posterImageView.frame)
        dismiss(animated: true)
    }
    

}
