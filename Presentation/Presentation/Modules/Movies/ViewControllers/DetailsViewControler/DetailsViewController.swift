//
//  DetailsViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 20.04.22.
//

import UIKit
import Core
import Kingfisher

class DetailsViewController: UIViewController {
    
    
    let dismissButton : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        btn.backgroundColor = .red
        return btn
    }()
    
    @objc func handleDismiss(sender: UIButton!) {
       
        self.dismiss(animated: true)
    }

    
    let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage(named: "poster", in: Bundle.presentationBundle, with: nil)
        imageView.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 250)
        return imageView
        
    }()
    
    let containerView = UIView()
    
    var movie : MovieData!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        posterImageView.backgroundColor = .white
        
        
        view.addSubview(posterImageView)
        view.addSubview(dismissButton)
       // containerView.addSubview(posterImageView)
      //  containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        posterImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 250))
        dismissButton.anchor(top: posterImageView.topAnchor, leading: nil, bottom: nil, trailing: posterImageView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 50, height: 50))
        let prefix = AppHelper.imagePathPrefix
        let url = URL(string: prefix + movie.backdropPath!)
        posterImageView.kf.setImage(with: url)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGestureRecognizer:)))
        view.addGestureRecognizer(gesture)
        
    }
    
    var translationX = CGFloat()
    var gestureInProgress =  false
    
    @objc func handlePan(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let viewToDrag = panGestureRecognizer.view else { return }
        let translation = panGestureRecognizer.translation(in: self.view)
        
        if panGestureRecognizer.state == .changed {
            var realTransition: CGFloat = 0
            if !self.gestureInProgress {
                self.translationX = translation.x
                realTransition = max(0, translation.x)
            } else {
                realTransition = abs(self.translationX) + translation.x
            }
            self.gestureInProgress = true
            
            viewToDrag.center = CGPoint(x: self.view.center.x + realTransition * 0.35,
                                        y: self.view.center.y + translation.y * 0.35)
            
            let distance = sqrt(pow(viewToDrag.center.x - self.view.center.x, 2) + pow(viewToDrag.center.y - self.view.center.y, 2)) * 0.5
            let scale = max(1 - (distance/viewToDrag.frame.height), 0.9)
            viewToDrag.transform = CGAffineTransform(scaleX: scale, y: scale)
            viewToDrag.layer.cornerRadius = 22
            viewToDrag.layer.masksToBounds = true
            
        }
        
        if panGestureRecognizer.state == .ended {
            let horizontalDismissOffset: CGFloat = 350
            let verticalDismissOffset: CGFloat = 350
            
            self.gestureInProgress = false
            
            let velocity = panGestureRecognizer.velocity(in: self.view)
            if abs(velocity.y) > verticalDismissOffset || abs(velocity.x) > horizontalDismissOffset {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    viewToDrag.center = CGPoint(x: self.view.center.x,
                                                y: self.view.center.y)
                    viewToDrag.transform = .identity
                    viewToDrag.layer.cornerRadius = 0
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // print(posterImageView.frame)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // print(posterImageView.frame)
    }
    

  

}
