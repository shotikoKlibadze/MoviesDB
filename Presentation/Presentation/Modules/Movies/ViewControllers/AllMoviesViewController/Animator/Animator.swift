//
//  Animator.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 19.04.22.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var sizeViewForTransition = UIView()
    var imageViewForTransition = UIImageView()

    

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let detailsViewController : MovieDetailsViewController = transitionContext.viewController(forKey: .to) as? MovieDetailsViewController  {
            animatePresent(using: transitionContext, to: detailsViewController, imageView: imageViewForTransition, sizeView: sizeViewForTransition)
        }
        
        if let detailsViewController : MovieDetailsViewController = transitionContext.viewController(forKey: .from) as? MovieDetailsViewController  {
            animateDismiss(using: transitionContext, from: detailsViewController, imageView: imageViewForTransition, sizeView: sizeViewForTransition)
        }
    }
    
    
    func animatePresent(using transitionContext: UIViewControllerContextTransitioning,
                            to viewController: MovieDetailsViewController,
                            imageView: UIImageView?,
                            sizeView: UIView?) {

        let containerView = transitionContext.containerView
        containerView.addSubview(viewController.view)
        viewController.view.alpha = 0
        
        let newContentView = UIView()
        newContentView.backgroundColor = .white
       // newContentView.layer.cornerRadius = 12
        newContentView.layer.cornerCurve = .continuous
        containerView.addSubview(newContentView)
        
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFill
        newImageView.image = imageView?.image
        newImageView.backgroundColor = .white
        //newImageView.layer.cornerRadius = 12
        newImageView.layer.cornerCurve = .continuous
        newImageView.clipsToBounds = true
        containerView.addSubview(newImageView)
        
        newImageView.frame = sizeView?.convert(sizeView?.frame ?? CGRect(), to: containerView) ?? CGRect()
        newContentView.frame = sizeView?.convert(sizeView?.frame ?? CGRect(), to: containerView) ?? CGRect()
        
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            newImageView.frame = CGRect(x: 0, y: 47, width: UIScreen.main.bounds.width, height: 300)

            newContentView.frame = (viewController.view.superview?.convert(viewController.view.frame, to: containerView)) ?? CGRect()
           
        }) { (_) in
            //newImageView.frame = CGRect(x: 0.0, y: 44.0, width: 390, height: 250)
            UIView.animate(withDuration: 0.1, animations: {
                viewController.view.alpha = 1
                //newImageView.frame = CGRect(x: 0.0, y: 44.0, width: 390, height: 250)
               
            }, completion: { _ in
                //print()
                //print("newImage" ,newImageView.frame)
               // print("the image", viewController.posterImageView.bounds)
                newImageView.removeFromSuperview()
                newImageView.alpha = 0
               
                newContentView.removeFromSuperview()
               
               
                UIView.animate(withDuration: 0.25, animations: {
                    viewController.view.alpha = 1
                   
                })
            })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animateDismiss(using transitionContext: UIViewControllerContextTransitioning,
                            from viewController: MovieDetailsViewController,
                            imageView: UIImageView?,
                            sizeView: UIView?) {
        let containerView = transitionContext.containerView
        containerView.addSubview(viewController.view)
        viewController.view.alpha = 1
        
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFill
        newImageView.image = imageView?.image
        newImageView.backgroundColor = .white
        //newImageView.layer.cornerRadius = 12
        newImageView.layer.cornerCurve = .continuous
        newImageView.clipsToBounds = true
        containerView.addSubview(newImageView)
        
        viewController.view.layoutIfNeeded()
        
        newImageView.frame = CGRect(x: 0, y: 47, width: UIScreen.main.bounds.width, height: 250)
        viewController.posterImageView.alpha = 0
        
        UIView.animate(withDuration: 0.1, animations: {
            viewController.view.alpha = 0
        })
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            newImageView.frame = sizeView?.superview?.convert(sizeView?.frame ?? CGRect(), to: containerView) ?? CGRect()
        }) { _ in
            imageView?.alpha = 1
            sizeView?.alpha = 1
            UIView.animate(withDuration: 0.15, animations: {
                newImageView.alpha = 0
            }, completion: {  (_) in
                newImageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }


}
