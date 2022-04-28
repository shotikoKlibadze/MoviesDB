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
    
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genresStackView: UIStackView!
    
    var movie : Movie!
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
       // print("will appear", posterImageView.frame)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
    
    
    private func setUI() {
        setupGradientLayer()
        tittleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        
        let imagePathPrefix = AppHelper.imagePathPrefix
        if let backgroundPoster = movie.backdropPath {
            let url = URL(string: imagePathPrefix + backgroundPoster)
            backgroundPosterImageView.kf.setImage(with: url)
        }
        let posterImage = movie.posterPath
        let url = URL(string: imagePathPrefix + posterImage)
        posterImageView.kf.setImage(with: url)
        
        for i in movie.genreIDS.indices {
            let labelView = GenreLabelView()
            if let genre = AppHelper.genres[movie.genreIDS[i]] {
                labelView.label.text = genre
                genresStackView.addArrangedSubview(labelView)
            }
        }
    }
    
    private func setupGradientLayer() {
        gradientView.bringSubviewToFront(posterImageView)
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.darkText.cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0.1, 0.4, 0.7]
        gradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = gradientView.bounds
    }
    
    @IBAction func dismiss(_ sender: Any) {
        print(backgroundPosterImageView.frame)
        dismiss(animated: true)
    }
    

}
