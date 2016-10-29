//
//  SplashScreenViewController.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class SplashScreenViewController: UIViewController {

    // MARK: - Initializer methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        perform(#selector(SplashScreenViewController.showMainController), with: nil, afterDelay: 1.5)
    }

    func showMainController() {
        performSegue(withIdentifier: "showMainViewController", sender: self)
    }
}
