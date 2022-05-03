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
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genresStackView: UIStackView!
    
    var movie : MovieEntity!
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureFavoriteButton()
        title = movie.tittle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        if let _ = navigationController {
            closeButton.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
    private func configureFavoriteButton() {
        guard movie.isFavorite else {
            favoriteButton.setImage(UIImage(named: "heart-stroke", in: Bundle.presentationBundle, with: nil), for: .normal)
            return
        }
        favoriteButton.setImage(UIImage(named: "heart-fill", in: Bundle.presentationBundle, with: nil), for: .normal)
    }
    
    
    
    private func setUI() {
        setupGradientLayer()
        tittleLabel.text = movie.tittle
        descriptionLabel.text = movie.overview
        ratingsLabel.text = String(movie.voteAvarage) + "/10"
        
        let imagePathPrefix = AppHelper.imagePathPrefix
        if let backgroundPoster = movie.wallPaper {
            let url = URL(string: imagePathPrefix + backgroundPoster)
            backgroundPosterImageView.kf.setImage(with: url)
        }
        let posterImage = movie.poster
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
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard movie.isFavorite else {
            movie.isFavorite = true
            CoreDataManager.shared.save(movie: movie)
            configureFavoriteButton()
            return
        }
        AppHelper.showActionAlert(viewController: self, title: movie.tittle, message: nil, cancelButtonTittle: "Cancel", actionButtonTitle: "Remove From Favorites", action: removeFromFavorites)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        //print(backgroundPosterImageView.frame)
        dismiss(animated: true)
    }
    
    private func removeFromFavorites() {
        CoreDataManager.shared.deleteMovie(movie: movie)
        movie.isFavorite = false
        configureFavoriteButton()
    }
    

}
