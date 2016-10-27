 //
//  SummaryViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/19/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit
import CoreData

class SummaryViewController: UIViewController {

    var categoryTapped = Int()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var wordSummaryLabel: UILabel!
    @IBOutlet weak var wordSummaryTextview: UITextView!

    

    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let words = NSMutableAttributedString()
        let cr = NSMutableAttributedString(string: "\n")
        
        // Retrieve the missed words.
        for missedWord in Game.sharedGameInstance.missedWordsArray {
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 23)]
            let myString = NSMutableAttributedString(string: missedWord, attributes:attrs)
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.length))
            
            words.append(myString)
            words.append(cr)
            self.wordSummaryTextview.attributedText = words
        }
        // Retrieve correct words.
        for correctWord in Game.sharedGameInstance.correctWordsArray {
            
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 23)]
            
            let myString = NSMutableAttributedString(string: correctWord, attributes:attrs)
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:0,length:myString.length))
          
            words.append(myString)
            words.append(cr)
            self.wordSummaryTextview.attributedText = words
        }
    
        self.wordSummaryTextview.textAlignment = .center
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.wordSummaryTextview.setContentOffset(CGPoint.zero, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let categoryColor = Game.sharedGameInstance.gameColor.cgColor

        self.mainView.layer.cornerRadius = 7
        self.mainView.layer.borderColor = categoryColor
        self.mainView.layer.borderWidth = 3
        self.backgroundView.layer.cornerRadius = 7
        self.wordSummaryLabel.textColor = Game.sharedGameInstance.gameColor
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Words Summary", attributes: underlineAttribute)
        self.wordSummaryLabel.attributedText = underlineAttributedString
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func backBtnTapped(_ sender: AnyObject) {
    }
        
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.colors[categoryTapped]
    }
}
