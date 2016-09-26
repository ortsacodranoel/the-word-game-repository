//
//  SummaryViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/19/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit


class SummaryViewController: UIViewController {

    // MARK: - General properties
    var categoryTapped = Int()
    
    // MARK: - Views
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    // MARK: - Label
    @IBOutlet weak var wordSummaryLabel: UILabel!
    
    
    // MARK: - Textviews
    
    @IBOutlet weak var missedWordsTextview: UITextView!
    @IBOutlet weak var correctWordsTextview: UITextView!
    
    
    
    // MARK: - Button Action
    @IBAction func returnToGameTouched(_ sender: AnyObject) {
        print("Return tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var missed = String()
        var correct = String()
        
        for missedWord in Game.sharedGameInstance.missedWordsArray {
            missed += "\(missedWord)\n"
        }
        
        self.missedWordsTextview.text = missed
        
        for correctWord in Game.sharedGameInstance.correctWordsArray {
            correct += "\(correctWord)\n"
        }
        
        self.correctWordsTextview.text = correct
        
        
       // print("In summaryVC")
        // Do any additional setup after loading the view.
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
