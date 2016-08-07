//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // Used to keep track of the current game.
    var game = Game()
    
    
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
    
    
    // Labels.
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    
    
    // Views.
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var teamOneScoreTitleView: UIView!
    @IBOutlet weak var teamOneScore: UIView!
    @IBOutlet weak var teamTwoScoreTitleView: UIView!
    @IBOutlet weak var teamTwoScore: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var TeamTitleView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var wordContainerView: UIView!
    
    
    // Animation variables. 
    var animatingLeft = false
 
    // Timer variables.
    var timer = NSTimer()
    
    var seconds = 00
    var time : String = ""
    var timeIsUp = false
    var minutes = 1

    // Constraints.
    @IBOutlet weak var centerAlignWordContainer: NSLayoutConstraint!

    
    // GestureRecognizers. 
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    
    // Additional variables.
    var answer = true
    var categoryTapped = Int()
    var teamTwoTurn = false
    var wordOnScreen = false
    var wordReset = true
    var wordRemoved = false
    var animationInProgress = false
    
    
    var swipedRight = false
    
    
    
    /**
        
        MARK: View Methods  *************************************************************************************************************
    
    **/
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Set initial values.
        displayTeam()
        
        // Change view background color.
        setColor(categoryTapped)
        
        // Set the team title.
        
        // Set current team scores.
        teamOneScoreLabel.text = String(game.getTeamOneScore())
        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
        
        // Set the time.
        //timeLeftLabel.text = String(seconds)
    
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Timer configuration.
        seconds = 00
        minutes = 01
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
        
        // Move the wordContainerView just out of view.
        self.centerAlignWordContainer.constant += view.bounds.width
        
        // Decrease wordContainerView's alpha.
        self.wordContainerView.alpha = 0
        
        startAnimations()
        
    }
    

    // MARK: Gesture Recognizers *******************************************************************************************************

    /**
 
     When the team know the answer they will swipe left.
 
    **/
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            
                // RIGHT - GestureRecognizer.
                case UISwipeGestureRecognizerDirection.Right:
                
                    
                    if wordOnScreen {
                        animatePassAnimation()
                    }
                

                // LEFT - GestureRecognizer.
                case UISwipeGestureRecognizerDirection.Left:
                
                    // Increment the score for the current team if the time is not up.
                    if game.teamOneIsActive && timeIsUp == false {
                        
                        // - SCORE UPDATES
                        
                        // Increment Team 1 score.
                        game.teamOneScore += 1
                        // Update Team 1 score text.
                        teamOneScoreLabel.text = String(game.getTeamOneScore())
                        
                        
                        // Generate new word.
                        animateToWordOrigin()
                        
                    } else if timeIsUp == false {
                       
                        // Increment Team 2 score.
                        game.teamTwoScore += 1
                        
                        // Present first WORD.
                        self.wordLabel.text = game.getWord()
                        
                        // Update score label.
                        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
                    }
                
                default:
                    break
                }
        }
    }

    
    /**
     
     MARK: Button methods ************************************************************************************************************

    */
    
    /**
        
        When the Menu Button is tapped it calls the segue to unwind
        back to the initial categories screen.

     */
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    /**
     
        Tapping the Start button calls the methods to remove the Start Button,
        the Categories Menu, and the current Team Title from the screen. It also
        sets the initial value of the Timer laber to 59, and calls the timer method
        to start counting down from 59.
     
     */
    @IBAction func startButtonTapped(sender: AnyObject) {
        
        // Animate offscreen: startButtonView and menuView
        removeTitleAnimations()
        
        // Animate the categories menu off screen.
        removeCategoriesMenu()
        
        // Set initial value for timer.
        seconds = 59
        minutes = 0
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
        
        // Run the timer.
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.startRound), userInfo:nil, repeats: true)
        }
    
        // Get a new word.
        self.wordLabel.text = game.getWord()

        // Animate word label onto screen.
        self.animateInitialWord()
    }
    
    
    /**
     
        Sets the title for the current team.
     
        - Parameter dog: String
     
    */
    func displayTeam () {
        if game.teamOneIsActive {
            teamLabel.text = "Team 1"
        } else {
            teamLabel.text = "Team 2"
        }
    }
    

    /**
     
     Sets the color of the background based on the category selected.
     
     - Parameter category: Int
     
     */
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    
    
    
    
    // ******************************************************************************** Start Method ****************************************************************************** //

    func startRound() {
        
        timeIsUp = false
        
        // Animate the timer.
        animateTimer()
            

        // Check if time has run out.
        if seconds == 0 {
        
            timeIsUp = true
            
            // Stop timer.
            timer.invalidate()
            
            // Change team. 
            game.switchTeams()
            
            // Update team titleLabel
            displayTeam()
            
            // Remove word.
            removeWord()
            
            // Reset timer configuration.
            seconds = 00
            minutes = 01
            let strMinutes = String(format: "%02d", minutes)
            let strSeconds = String(format: "%02d", seconds)
            self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
        
            // Reset animations
            resetMenuAnimations()
            
        }
    }

    

    // ******************************************************************************** Animations ******************************************************************************** //
    
    
    
    /**
     
        The initial word animation moves the wordContainerView into view from the left side
        of the screen.
     
     **/
    func animateInitialWord() {
        
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.wordContainerView.alpha = 1
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            self.wordOnScreen = true
            }, completion: nil)
    }
    
    
    /**
    
     
     
    */
    func animateToWordOrigin() {
       
        // Animates the word to the left off the screen.
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()

        }, completion: nil)
        
        UIView.animateWithDuration(0.0, delay:0.3, options: [], animations: {

                self.centerAlignWordContainer.constant += self.view.bounds.width + self.view.bounds.width
                self.wordContainerView.alpha = 1
                self.view.layoutIfNeeded()
                
            }, completion: {(Bool) in
                self.wordLabel.text = self.game.getWord()
                })

        
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }
    
    /**
     
     The initial word animation moves the wordContainerView into view from the left side
     of the screen.
     
     **/
    func animatePassAnimation() {
        
        // If pass count less than 2 then ...
        
        
        // Animates right offscreen.
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
                self.wordLabel.text = self.game.getWord()
        })


        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }


    /**
 
     
     
    */
    func removeWord() {
        
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            print(self.centerAlignWordContainer.constant)
            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // MENU ANIMATIONS *******************************************************************************************************************************************

    
    /**
     Move startButton, teamLabel, and menuView OFF screen.
    */
    func removeTitleAnimations() {
        
        UIView.animateWithDuration(0.5, delay:0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {

                                    self.startButton.userInteractionEnabled = false
                                    self.startButton.center.y += self.view.bounds.height
                                    self.startButton.alpha = 0
                                    
                                    // TeamLabel setup.
                                    self.teamLabel.center.y -= self.view.bounds.height
                                    self.teamLabel.alpha = 0
            }, completion: nil)
    }
    
    
    /**
     
     Removes the categories menu button by animating the menu up off
     the screen.
     
     */
    func removeCategoriesMenu() {
        
        UIView.animateWithDuration(0.0, delay:0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.menuView.alpha = 0
                                    self.menuView.userInteractionEnabled = false
                                    self.menuView.center.y += self.view.bounds.height
                                    
            }, completion: nil)
    }

    func resetMenuAnimations () {
        
        UIView.animateWithDuration(0.5, delay:0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.menuView.userInteractionEnabled = true
                                    self.menuView.alpha = 1
                                    self.menuView.center.y += self.view.bounds.height
                                               }, completion: nil)

        UIView.animateWithDuration(0.5, delay:0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                
                                    self.startButton.userInteractionEnabled = true
                                    self.startButton.center.y -= self.view.bounds.height
                                    self.startButton.alpha = 1
                                    
                                    self.teamLabel.alpha = 1
                                    self.teamLabel.center.y += self.view.bounds.height
                                    
            }, completion: nil)
    }
    
    
    // The method start all animations once the GameVC loads.
    func startAnimations() {
      
        // TEAM 1
        UIView.animateWithDuration(0.5, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {

            self.teamOneScoreTitleView.alpha = 1
            self.teamOneScoreTitleView.center.y -= self.view.bounds.height
                
        }, completion: nil)
       
        // TEAM 1 SCORE.
        UIView.animateWithDuration(0.5, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamOneScore.alpha = 1
            self.teamOneScore.center.y -= self.view.bounds.height
            
        }, completion: nil)
        
        //TEAM 2.
        UIView.animateWithDuration(0.5, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamTwoScoreTitleView.alpha = 1
            self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
        
        }, completion: nil)
        
        // TEAM 2 SCORE.
        UIView.animateWithDuration(0.5, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamTwoScore.alpha = 1
            self.teamTwoScore.center.y -= self.view.bounds.height
            
        }, completion: nil)
        
        // Start and Title.
        UIView.animateWithDuration(0.5, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.TeamTitleView.alpha = 1
            self.TeamTitleView.center.y += self.view.bounds.height

            self.startButton.alpha = 1
            self.startButton.center.y -= self.view.bounds.height
            
        }, completion: nil)
        
        // Categories Menu button animations.
        UIView.animateWithDuration(0.5, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
          self.menuView.alpha = 1
          self.menuView.center.y += self.view.bounds.height
          
            }, completion: nil)
    }
    
    
    /**
     
     Animates the timer.
     
     **/
    func animateTimer() {
        
        // Decrease the time.
        seconds -= 1
        minutes = 0
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
}

