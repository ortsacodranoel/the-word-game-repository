//
//  CollectionViewCell.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK - Variables
    var category : String = ""
    var cellTag : Int = -1
    
    @IBOutlet weak var categoryButton: UIButton!
   
    
    @IBAction func buttonTouched(sender: AnyObject) {
        
    }
}