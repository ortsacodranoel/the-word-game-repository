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
    

    @IBOutlet weak var summaryCenterX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UIView.animate(withDuration: 1.0, delay: 6.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.summaryCenterX.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.summaryCenterX.constant += self.view.bounds.width
    }
    
    
    // MARK: - Animations

}
