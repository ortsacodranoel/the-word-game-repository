//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class CategoriesTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    fileprivate var presenting = true
    
    // MARK: Information passed.
    var CategoryTapped = Int()
    
    // Animate transition between View Controllers.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        // Get reference to fromView, toView, and containerView.
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // Setup 2D transformations.
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        if (self.presenting) {
            toView.transform = offScreenRight
        }
        else {
            toView.transform = offScreenLeft
        }
        
        
        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)
        
        
        let duration = self.transitionDuration(using: transitionContext)
        
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
            
            
            if (self.presenting){
                fromView.transform = offScreenLeft
            }
            else {
                fromView.transform = offScreenRight
            }
            
                toView.transform = CGAffineTransform.identity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
        })
        
    }
    
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}

