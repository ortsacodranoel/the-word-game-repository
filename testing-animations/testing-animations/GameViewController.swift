//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Variables.
    var answer = true
    var categoryTapped = Int()
    
    
    // MARK: - Data.
    let colors = [UIColor(red: 147/255, green: 126/255, blue: 211/225, alpha: 1),   // Jesus
        UIColor(red: 62/255, green: 166/255, blue: 182/225, alpha: 1),  // People
        UIColor(red: 202/255, green: 115/255, blue: 99/225, alpha: 1),  // Places
        UIColor(red: 215/255, green: 184/255, blue: 136/225, alpha: 1),  // Famous
        UIColor(red: 55/255, green: 98/255, blue: 160/225, alpha: 1),  // Worship
        UIColor(red: 163/255, green: 56/255, blue: 120/225, alpha: 1),  // Books
        UIColor(red: 199/255, green: 176/255, blue: 87/225, alpha: 1),  // Concordance
        UIColor(red: 159/255, green: 200/255, blue: 223/225, alpha: 1),  // Feasts
        UIColor(red: 48/255, green: 142/255, blue: 145/225, alpha: 1),  // Angels
        UIColor(red: 178/255, green: 215/255, blue: 255/225, alpha: 1),  // Sunday
        UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),  // Revelation
        UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),  // Doctrine
        UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),  // Sins
        UIColor(red: 150/255, green: 165/255, blue: 141/225, alpha: 1),  // Commands
    ]
    

    // MARK: - Label
    @IBOutlet weak var timeLeftLabel: UILabel!

    
    // MARK: - Views.
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var teamOneScoreTitleView: UIView!
    @IBOutlet weak var teamOneScore: UIView!
    @IBOutlet weak var teamTwoScoreTitleView: UIView!
    @IBOutlet weak var teamTwoScore: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var TeamTitleView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    
 
    // MARK: - Timer variables.
    var timer = NSTimer()
    var counter = 60
    var time : String = ""
    
    @IBAction func menuButtonTapped(sender: AnyObject) {
        print("Button Tapped")
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view alpha levels for animations.
        timerView.alpha = 0
        teamOneScoreTitleView.alpha = 0
        teamTwoScoreTitleView.alpha = 0
        teamTwoScore.alpha = 0
        teamOneScore.alpha = 0
        menuView.alpha = 0
        TeamTitleView.alpha = 0
        startButtonView.alpha = 0
        
        // Change view background color.
        setColor(categoryTapped)


        // Timer configuration.
        
        
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.updateTime), userInfo:nil, repeats: true)
            //timer.fire()
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        
        // Setup view positions for animations.
        timerView.center.y = -200
        teamOneScoreTitleView.center.y = 200
        teamOneScore.center.y = 200
        teamTwoScoreTitleView.center.y = 200
        teamTwoScore.center.y = 200
        menuView.center.y = -200
        TeamTitleView.center.y = -200
        startButtonView.center.y = 200
        
        self.startAnimations()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    //MARK: - Custom methods.
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    func updateTime() {
        counter -= 1
        self.timeLeftLabel.text = String(counter)
//        if counter == 57 {
//            
//            print("Stop")
//            timer.invalidate()
//            return
//        }
    
    }
    
    func startAnimations() {
      
        UIView.animateWithDuration(0.2, delay: 1.8,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.timerView.alpha = 1.0
                                    self.timerView.center.y = 25
            }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 1.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamOneScoreTitleView.alpha = 1.0
                                    self.teamOneScoreTitleView.center.y = 25
            }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 1.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamOneScore.alpha = 1.0
                                    self.teamOneScore.center.y = 25
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 1.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamTwoScoreTitleView.alpha = 1.0
                                    self.teamTwoScoreTitleView.center.y = 25
            }, completion: nil)
        
        
        // Menu and Timer animations.
        UIView.animateWithDuration(0.2, delay: 1.6,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamTwoScore.alpha = 1.0
                                    self.teamTwoScore.center.y = 25
                                    self.menuView.alpha = 1.0
                                    self.menuView.center.y = 25
            }, completion: nil)
        
        // Team turn TitleView.
        UIView.animateWithDuration(0.2, delay: 2.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.TeamTitleView.alpha = 1.0
                                    self.TeamTitleView.center.y = 25
                                    self.startButtonView.alpha = 1.0
                                    self.startButtonView.center.y = 25
            }, completion: nil)
    }


}
