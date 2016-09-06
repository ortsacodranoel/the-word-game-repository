//
//  spashScreenViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/6/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class spashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        performSelector(#selector(spashScreenViewController.showMainController), withObject: nil, afterDelay: 3.0)
        
    }
    
    
    func showMainController()
    {
        performSegueWithIdentifier("showMainViewController", sender: self)
    }
    
    
}
