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
    
    // MARK:- Initialization
    
    
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)

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

