//
//  CollectionViewCell.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    var category : String = ""
    var cellTag : Int = -1
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var lockView: UIView!
    
    @IBAction func buttonTouched(_ sender: AnyObject) {
    }
}
