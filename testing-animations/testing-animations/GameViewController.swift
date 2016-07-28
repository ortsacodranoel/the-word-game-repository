//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    
    // Game Object:
    let game = Game()
    
    // MARK: - Variables.
    var answer = true
    var categoryTapped = Int()
    var gameStarted = false
    var teamTwoTurn = false
    
    // Variable to start animations. 
    var initialAnimations = true
    
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
    

    // MARK: - Outlets
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
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
    
    
    // MARK: Button Actions.

    @IBAction func menuButtonTapped(sender: AnyObject) {
        print("Button Tapped")
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        
        // Start a new game countdown.
        gameStarted = true
        
        
        // Run the timer.
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.updateTime), userInfo:nil, repeats: true)
            print("in timer loop")
        }
        
        // Animate offscreen: startButtonView and menuView
        removeAnimations()
    }
    
    
    
    
    func updateGameInfo() {

        // Update team turn variable.
        if game.teamOneTurn == true {
            
            game.teamOneTurn = false
            
            print("Team 2 turn")
            
            teamLabel.text = game.getCurrentTeamTurn()
            
            return
            
        } else {
            
            game.teamOneTurn = true
            
            teamLabel.text = game.getCurrentTeamTurn()
            
            return
        }
    }

    
    
    
    

    
    
    //MARK: - Custom methods.
    
    func setTeamTitle() {
            teamLabel.text = game.getCurrentTeamTurn()
    }
    

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
        } else {  }
    }
    
    

    
    // MARK: Animations

    // Remove startButton, teamLabel, and menuView from screen.
    func removeAnimations() {
        
        UIView.animateWithDuration(0.5, delay:0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    
                                    self.menuView.userInteractionEnabled = false
                                    self.startButton.userInteractionEnabled = false
                                    
                                    self.menuView.center.y -= self.view.bounds.height
                                    self.teamLabel.center.y -= self.view.bounds.height
                                    self.startButton.center.y += self.view.bounds.height
                                    
                                    self.startButton.alpha = 0
                                    self.teamLabel.alpha = 0
                                    self.menuView.alpha = 0
            }, completion: nil)
    }

    
    
    
    /*
     This method resets the menuView, StartButtonView, and TeamView by placing them
     at their original start positions, increasing alpha values, and enabling user interaction.
     */
    func resetAnimations () {
        
        updateGameInfo()
        
        UIView.animateWithDuration(0.5, delay:0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    
                                    self.menuView.userInteractionEnabled = true
                                    self.startButton.userInteractionEnabled = true
                                    
                                    self.menuView.center.y += self.view.bounds.height
                                    self.teamLabel.center.y += self.view.bounds.height
                                    self.startButton.center.y -= self.view.bounds.height
                                    
                                    self.startButton.alpha = 1
                                    self.teamLabel.alpha = 1
                                    
            }, completion: nil)

        UIView.animateWithDuration(0.5, delay:0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    
                                    self.menuView.userInteractionEnabled = true
                                    self.menuView.alpha = 1
                                    self.menuView.center.y += self.view.bounds.height

            }, completion: nil)
        
        
    }
    
    

    
    
    
    
    
    
    
    func startAnimations() {
        
        UIView.animateWithDuration(0, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    // Team 1 & Team 2.
                                    self.teamOneScoreTitleView.alpha = 1
                                    self.teamOneScoreTitleView.center.y -= self.view.bounds.height
                                    self.teamTwoScoreTitleView.alpha = 1
                                    self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
                                   
                                    
                                    // Scores.
                                    self.teamOneScore.alpha = 1
                                    self.teamOneScore.center.y -= self.view.bounds.height
                                   
                                    self.teamTwoScore.alpha = 1
                                    self.teamTwoScore.center.y -= self.view.bounds.height
                                    
                                    
                                    // Menu.
                                    self.menuView.alpha = 1
                                    self.menuView.center.y += self.view.bounds.height
                                    
                                    // Timer.
                                    self.timerView.alpha = 1
                                    self.timerView.center.y += self.view.bounds.height
                                    
                                    
                                    self.TeamTitleView.alpha = 1
                                    self.TeamTitleView.center.y += self.view.bounds.height
                                    
                                    self.startButton.alpha = 1
                                    self.startButton.center.y -= self.view.bounds.height
            }, completion: nil)
        }

    

    
    
    
    
    
    
    
    
    // Apple Code #############################
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        // Change view background color.
        setColor(categoryTapped)
        
        // Set the team title.
        setTeamTitle()
        
        // Set current team scores.
        teamOneScoreLabel.text = String(game.getTeamOneScore())
        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
        
        // Set the time.
        timeLeftLabel.text = String(counter)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if initialAnimations == true {
            print("viewDidAppear")
            startAnimations()
            initialAnimations = false
        }
    }
    
    
    
    
    
    
    
    

}

