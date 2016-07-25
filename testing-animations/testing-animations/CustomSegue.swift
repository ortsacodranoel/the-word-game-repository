//
//  CustomSegue.swift
//  testing-animations
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {

    override func perform() {
        
        // Create two temp. variables for first and second view controllers. 
        let sourceViewController = self.sourceViewController
        let destinationViewController = self.destinationViewController
        
        

        
        
        // Add the Destination View Controller's view as subview of current Source View Controller
        sourceViewController.view.addSubview(destinationViewController.view)
        
        // Make the view tiny. 
        // destinationViewController.view.transform = CGAffineTransformationMakeScale(0.05, 0.05)
        
        // This block is where animation is performed. 
        UIView.animateWithDuration(0.5, delay:0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            // Enlarge the Destination View Controller's view. 
            //destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            
            
        }) { (finished) -> Void in
        
        
            // Need to remove the Dest. VC from the Source VC.
            destinationViewController.view.removeFromSuperview()
            
            // Present the DestinationVC, but we can't do it in the same loop b/c it will create an unbalanced call. 
            
            // Set a time delay.
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
            
            // Exceute at this point.
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
          
                sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
            })
        }
    }
}
