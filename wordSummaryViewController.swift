//
//  wordSummaryViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/13/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class summaryScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("SummaryScreenViewController loaded")
        Game.sharedGameInstance.printCorrectMissedArray()
    }
    

    
}
