//
//  RulesTransitionManager.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//


import UIKit

class RulesTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    fileprivate var presenting = true
    var CategoryTapped = Int()
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let categoriesView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let rulesView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        if (self.presenting) {
            rulesView.transform = offScreenRight
        }
        else {
            rulesView.transform = offScreenLeft
        }
        
        container.addSubview(rulesView)
        container.addSubview(categoriesView)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
            if (self.presenting){
                categoriesView.transform = offScreenLeft
            }
            else {
                categoriesView.transform = offScreenRight
            }
                rulesView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
        
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}

