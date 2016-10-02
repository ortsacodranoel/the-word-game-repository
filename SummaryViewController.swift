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
        
        
        // Used to append correct/missed words.
        let words = NSMutableAttributedString()
        // Used to add the carriage return to the attributed string passed to the wordSummaryTextview.
        let cr = NSMutableAttributedString(string: "\n")
        // Retrieve the missed words.
        for missedWord in Game.sharedGameInstance.missedWordsArray {
            // Used as temp storage for missed words.
            let myString = NSMutableAttributedString (string: missedWord, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 25.0)!])
            // Used to color the missed words red.
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.length))
            words.append(myString)
            // Append carriage return.
            words.append(cr)
            self.wordSummaryTextview.attributedText = words
            
        }
        // Retrieve correct words.
        for correctWord in Game.sharedGameInstance.correctWordsArray {
            // Used as temp storage for missed words.
            let myString = NSMutableAttributedString (string: correctWord, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 25.0)!])
            // Used to color the missed words green.
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:0,length:myString.length))
            words.append(myString)
            // Append carriage return.
            words.append(cr)
            self.wordSummaryTextview.attributedText = words
        }
        

        self.wordSummaryTextview.textAlignment = .center
    
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.wordSummaryTextview.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    /// Method:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /// Method:
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

        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Words Summary", attributes: underlineAttribute)
        self.wordSummaryLabel.attributedText = underlineAttributedString
        

        
        

    }
    
    
    
    
    
    
    /// Set the initial background color of the main view.
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.colors[categoryTapped]
    }
}
