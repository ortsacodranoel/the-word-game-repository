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
        
        perform(#selector(spashScreenViewController.showMainController), with: nil, afterDelay: 3.0)
        
    }
    
    
    func showMainController()
    {
        performSegue(withIdentifier: "showMainViewController", sender: self)
    }
    
    
}
