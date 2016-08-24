//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
    
    // MARK: - Game Properties

    @IBOutlet weak var rulesScrollView: UIScrollView!
    
    // MARK: - Labels
    @IBOutlet weak var rulesTitle: UILabel!
    @IBOutlet weak var ruleOne: UILabel!
    @IBOutlet weak var ruleTwo: UILabel!
    @IBOutlet weak var ruleThree: UILabel!
    @IBOutlet weak var ruleFour: UILabel!
    @IBOutlet weak var ruleFive: UILabel!
    @IBOutlet weak var ruleSix: UILabel!
    
    @IBOutlet weak var rulesLabel: UILabel!

    // MARK:- Initialization
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    
    // MARK: - Button Actions.
    
    /**
        Used to link to the official rules page.
    */
    @IBAction func rulesButtonTapped(sender: AnyObject) {
        if let url = NSURL(string: "http://www.thewordgameapp.com/official-rules-of-the-game/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Transition Managers
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Swipe Gesture Recognizer Properties
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Swipe Right - Gesture Recognizer.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        UIView.animateWithDuration(0.4, delay: 1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
           // self.rulesLabel.alpha = 1
        
            }, completion: nil)
    }
    

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right: // RIGHT SWIPE
                performSegueWithIdentifier("unwindToCategories", sender: self)
            default:
                break
            }
        }
    }
    
    
}

