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
    var gameStarted = false
    
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
    
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        
        // Run the timer.
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.updateTime), userInfo:nil, repeats: true)
        }
        
        // Animate offscreen: startButtonView and menuView
        UIView.animateWithDuration(1.0, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.menuView.center.y -= self.view.bounds.height
                                    self.TeamTitleView.center.y -= self.view.bounds.height
                                    self.startButtonView.center.y += self.view.bounds.height
                                    
                                    self.menuView.userInteractionEnabled = false
                                    self.startButtonView.userInteractionEnabled = false
                                    
                                    self.startButtonView.alpha = 0
                                    self.TeamTitleView.alpha = 0
                                    self.menuView.alpha = 0
            }, completion: nil)
        
        // Start a new game countdown.
        gameStarted = true
        
    }
    
    
    
    // Apple code ############################################################################################################################################################################
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change view background color.
        setColor(categoryTapped)
    
        timeLeftLabel.text = String(counter)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startAnimations()
    }
    
    
    //MARK: - Custom methods.
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    
    func updateTime() {
        
        if (self.gameStarted == true)
        {
            counter -= 1
            self.timeLeftLabel.text = String(counter)
            
            // Check if time has run out.
                if counter == 57 {
                    
                    // Stop timer.
                    timer.invalidate()
                    
                    
                    // Reset for next team.
                    gameStarted = false
                    counter = 60
                    self.timeLeftLabel.text = String(counter)
                    print("Time's up!")
                    
                    resetAnimations()
                    
                    
                    return
                }
        } else { return }
    }
    
    
    // MARK: Animations ############################################################################################################################################################################
    
    /*
     This method resets the menuView, StartButtonView, and TeamView by placing them
     at their original start positions, increasing alpha values, and enabling user interaction.
     */
    func resetAnimations() {
        self.menuView.alpha = 1
        self.TeamTitleView.alpha = 1
        self.startButtonView.alpha = 1
        
        self.menuView.userInteractionEnabled = true
        self.TeamTitleView.userInteractionEnabled = true
        self.startButtonView.userInteractionEnabled = true
        
        UIView.animateWithDuration(0.2, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.menuView.center.y += self.view.bounds.height
                                    self.TeamTitleView.center.y += self.view.bounds.height
                                    self.startButtonView.center.y -= self.view.bounds.height
                                    
            }, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func startAnimations() {
        
        UIView.animateWithDuration(0.2, delay: 1.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamOneScoreTitleView.alpha = 1.0
                                    self.teamOneScoreTitleView.center.y -= self.view.bounds.height
            }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 1.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamOneScore.alpha = 1.0
                                    self.teamOneScore.center.y -= self.view.bounds.height
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 1.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.teamTwoScoreTitleView.alpha = 1.0
                                    self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
            }, completion: nil)
        
        

        UIView.animateWithDuration(0.2, delay: 1.6,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    
                                    // teamTwoScore animations.
                                    self.teamTwoScore.alpha = 1.0
                                    self.teamTwoScore.center.y -= self.view.bounds.height
                                    
                                    // menuView animations.
                                    self.menuView.alpha = 1.0
                                    self.menuView.center.y += self.view.bounds.height
                                    
                                    // timerView animations.
                                    self.timerView.alpha = 1.0
                                    self.timerView.center.y += self.view.bounds.height
            }, completion: nil)
        

        UIView.animateWithDuration(0.2, delay: 2.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.TeamTitleView.alpha = 1.0
                                    self.TeamTitleView.center.y += self.view.bounds.height
                                    self.startButtonView.alpha = 1.0
                                    self.startButtonView.center.y -= self.view.bounds.height
            }, completion: nil)
    }

    
    
    
    
    

}

