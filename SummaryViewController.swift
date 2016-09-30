 //
//  SummaryViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/19/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class SummaryViewController: UIViewController {

    // MARK: - General properties
    var categoryTapped = Int()
    
    // MARK: - Views
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    // MARK: - Label
    @IBOutlet weak var wordSummaryLabel: UILabel!
    
    @IBOutlet weak var wordSummaryTextview: UITextView!
    
    // MARK: - Textviews

    
    
    
    // MARK: - Button Action
    @IBAction func returnToGameTouched(_ sender: AnyObject) {
        print("Return tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var missed = NSMutableAttributedString()
  //      var word = String
        
        //    var correct = String()
        
        for missedWord in Game.sharedGameInstance.missedWordsArray {
           
            let myString = NSMutableAttributedString (string: missedWord, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 40.0)!])
                
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.length))
            
            missed.append(myString)
            
            self.wordSummaryTextview.text = "\(missed)\n"
        }
    
        
        // Show missed words.
      //  self.wordSummaryTextview.attributedText = missed
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the color of the category.
        let categoryColor = Game.sharedGameInstance.gameColor.cgColor
        // Setup view styles.
        self.mainView.layer.cornerRadius = 7
        self.mainView.layer.borderColor = categoryColor
        self.mainView.layer.borderWidth = 3
        self.backgroundView.layer.cornerRadius = 7
        
        self.wordSummaryLabel.textColor = Game.sharedGameInstance.gameColor
        
    }
    
    
    
    
    
    
    /// Set the initial background color of the main view.
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.colors[categoryTapped]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
