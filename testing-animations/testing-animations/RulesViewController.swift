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
    
    
    
    // MARK:- Initialization
    
    
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)

    }
    
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
    

    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

