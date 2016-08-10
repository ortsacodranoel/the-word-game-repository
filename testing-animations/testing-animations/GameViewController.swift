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
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    
    
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
    @IBOutlet weak var timeUpView: UIView!
    @IBOutlet var mainView: UIView!
    
    
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

    
    // GestureRecognizers variables.
    let swipeRecognizer = UISwipeGestureRecognizer()
    var swipedRight = false
    var timesSwipedRight = 0
    
    
    // Additional variables.
    var answer = true
    var categoryTapped = Int()
    var teamTwoTurn = false
    var wordOnScreen = false
    var wordReset = true
    var wordRemoved = false
    var animationInProgress = false
    

    
    
    

    // ******************************************** MARK: View Methods *************************************************** //    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Swipe Right - Gesture Recognizer.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        // Swipe Left - Gesture Recognizer.
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Set initial value to display current team turn.
        displayTeam()
        
        

        
        // Change view background color.
        setColor(categoryTapped)
        
        // Set current team scores.
        teamOneScoreLabel.text = String(game.getTeamOneScore())
        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
        
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
        

        // Setup team labels.
        team1Label.text = "Team 1"
        
        self.passesLabel.alpha = 0
        
        // Move the wordContainerView just out of view.
        self.centerAlignWordContainer.constant += view.bounds.width
        

        self.timeUpView.alpha = 0
        self.timeUpView.userInteractionEnabled = false
        

        animationsStart()
    }
    

    // ******************************************** MARK: Initializers *************************************************** //
    
    /**
     
     */
    func startRound() {
        
        timeIsUp = false

        
        // Animate the timer.
        animateTimer()
        
        
        if seconds == 50 {
            // Make the screen turn red to indicate time running out.
            self.animateTimeRunningOutFadeIn()
            
        }
        
        if seconds == 50 {
            // Display label with 'Time's Up!' message.
            self.animateTimeIsUpMessageOnScreen()
        }
        
        // Check if time has run out.
        if seconds == 50 {
            
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
            
        }
    }

    

    // ******************************************** MARK: Gesture Recognizers ******************************************** //
    
    /**
     When the team know the answer they will swipe left. When they do not, they can pass on the 
     word by swiping right. Each team is limited to 2 passes per round.
    */
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            
                // RIGHT - GestureRecognizer.
                case UISwipeGestureRecognizerDirection.Right:
                    

                    
                    print("in gesture:\(timesSwipedRight)")
                    
                
                    // Animate word to the right offscreen and create a new word.
                    if wordOnScreen && timesSwipedRight < 2 {
                      
                        // Increase times swiped right.
                        timesSwipedRight += 1
                        
                        // Create and display new word.
                        animateNewWordRightSwipe()
                    } else {
                        animatePassMessage()
                    }
                
                

                // LEFT - GestureRecognizer.
                case UISwipeGestureRecognizerDirection.Left:
                
                    // Check if team one is active and that time is still valid.
                    if game.teamOneIsActive && timeIsUp == false {
                        
                        // Increment Team 1 score.
                        game.teamOneScore += 1
                        // Update Team 1 score text.
                        teamOneScoreLabel.text = String(game.getTeamOneScore())
                        
                        // Create new word.
                        animateNewWordLeftSwipe()
                        
                    } else if timeIsUp == false {
                       
                        // Increment Team 2 score.
                        game.teamTwoScore += 1
                        // Update score label.
                        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
                    
                        // Create new word.
                        animateNewWordLeftSwipe()
                }
                
                default:
                    break
                }
        }
    }

    
    // ******************************************** MARK: Button Actions ************************************************* //
    
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
        
        // Reset right swipe count.
        self.timesSwipedRight = 0
        
        
        // Animate offscreen: startButtonView and menuView
        animateTitleOffScreen()
        
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
        self.wordLabel.text = game.getWord(self.categoryTapped)

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
    

    
    // ******************************************** MARK: Animations (Swipes) ******************************************** //
    
    /**
     Only two passes are allowed per game. This method fades in the 'Only 2 Passes' message with a duration of 0.5 seconds.
    */
    func animatePassMessage() {
      
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
                self.passesLabel.alpha = 1
            
            }, completion: {(bool) in
                self.animatePassMessageFadeOut()
        })
    }
    
    
    /**
     Fadeout
     
    */
    func animatePassMessageFadeOut(){
        
        UIView.animateWithDuration(0.5, delay:1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.passesLabel.alpha = 0
            
            }, completion: nil)
    }
    
    
    /**
     Animates the wordViewContainer left off-screen, followed by an animation of the container
     back to its original position to the right off-screen, finalizing by animating a new word
     to the middle of the screen. It also calls the .getWord() method to create the new word
     that is animated onto the screen.
     */
    func animateNewWordLeftSwipe() {
        
        // Animates wordViewContainer to the left off-screen.
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        // Places wordContainerView in its original position to the right of the screen.
        UIView.animateWithDuration(0.0, delay:0.3, options: [], animations: {
            
            self.centerAlignWordContainer.constant += self.view.bounds.width + self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
                
                // Get a new word.
                self.wordLabel.text = self.game.getWord(self.categoryTapped)
        })
        
        // Animates wordViewController to the middle of the screen.
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    /**
     The initial word animation moves the wordContainerView into view from the left side
     of the screen.
     */
    func animateNewWordRightSwipe() {
        
        // Animates right offscreen.
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
                
                // Get a new word.
                self.wordLabel.text = self.game.getWord(self.categoryTapped)
        })
        
        
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    
        
    }
    

    // ******************************************** MARK: Animations ***************************************************** //
    

    /**
     Animates all objects when the GameViewController loads.
    */
    func animationsStart() {
        
        // Team 1 - Score view
        UIView.animateWithDuration(0.4, delay: 0.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamOneScoreTitleView.alpha = 1
            self.teamOneScoreTitleView.center.y -= self.view.bounds.height
            
            }, completion: nil)
        
        // Team 1 - Score.
        UIView.animateWithDuration(0.4, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamOneScore.alpha = 1
            self.teamOneScore.center.y -= self.view.bounds.height
            
            }, completion: nil)
        
        //Team 2 - Score view.
        UIView.animateWithDuration(0.4, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamTwoScoreTitleView.alpha = 1
            self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
            
            }, completion: nil)
        
        // Team 2 - Score.
        UIView.animateWithDuration(0.4, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.teamTwoScore.alpha = 1
            self.teamTwoScore.center.y -= self.view.bounds.height
            
            }, completion: nil)
        
        // Categories Menu button animations.
        UIView.animateWithDuration(0.4, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.menuView.alpha = 1
            self.menuView.center.y += self.view.bounds.height
            
            }, completion: nil)
        
        // Start and Title.
        UIView.animateWithDuration(0.4, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.TeamTitleView.alpha = 1
            self.TeamTitleView.center.y += self.view.bounds.height
            
            self.startButton.alpha = 1
            self.startButton.center.y -= self.view.bounds.height
            
            }, completion: nil)
    }

    
    /**
     Animates word onto the screen from the left side.
     */
    func animateInitialWord() {
        
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.wordContainerView.alpha = 1
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            self.wordOnScreen = true
            }, completion: nil)
    }
    
    

    // ******************************************** MARK: Animations (Removing) ****************************************** //
    
    
    /**
     Remove the wordContainerView from the screen.
    */
    func removeWord() {
        
        UIView.animateWithDuration(0.4, delay:0.0, options: [], animations: {

            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    /**
     Animates menuView off-screen.
    */
    func animateMenuOffScreen() {
        
        UIView.animateWithDuration(0.3, delay:0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    // menuView properties.
                                    self.menuView.alpha = 0
                                    self.menuView.userInteractionEnabled = false
                                    self.menuView.center.y -= self.view.bounds.height
                                    
            }, completion: nil)
        

    }

    
    /**
     Animates menuView, startButton, and teamLabel to their initial positions on-screen.
    */
    func animateTitleOnScreen() {
        
        UIView.animateWithDuration(0.5, delay:0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.menuView.userInteractionEnabled = true
                                    self.menuView.alpha = 1

                                    
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
    

    /**
     Animate startButton and teamLabel off-screen.
     */
    func animateTitleOffScreen() {
        
        UIView.animateWithDuration(0.5, delay:0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    // startButton properties.
                                    self.startButton.userInteractionEnabled = false
                                    self.startButton.center.y += self.view.bounds.height
                                    self.startButton.alpha = 0
                                    
                                    // teamLabel properties.
                                    self.teamLabel.center.y -= self.view.bounds.height
                                    self.teamLabel.alpha = 0
                                    
                                    self.animateMenuOffScreen()
                                    
            }, completion: nil)
    }
    

    // ******************************************** MARK: Animations Time Running Out ************************************ //
    
    /**
     Animates TimeUpView on-screen.
    */
    func animateTimeIsUpMessageOnScreen() {

            UIView.animateWithDuration(0.2, delay:0.2,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 0.9,
                                       options: [], animations: {
                                        
                                        self.timeUpView.alpha = 1
                                        self.timeUpView.center.y += self.view.bounds.height

                }, completion: { (bool) in
                    
                    self.animateTimeIsUpMessageOffScreen()
            })
    }
    
    
    /**
     Animates TimeUpView with the message "Time's up!" off-screen.
    */
   func animateTimeIsUpMessageOffScreen() {
  
        UIView.animateWithDuration(0.2, delay:1.0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.9,
                               options: [], animations: {
                                
                                self.timeUpView.alpha = 0
                                self.timeUpView.center.y -= self.view.bounds.height
                                
            }, completion: { (bool) in
                
                // Reset the menu items.
                self.animateTitleOnScreen()
        })
    
   }
    
    
    /**
     Changes the color of the screen to red with a duration of 2.0 seconds. On completion it restes the
     color back to its original state.
     */
    func animateTimeRunningOutFadeIn() {
        
        
        UIView.animateWithDuration(1.0, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.view.backgroundColor = UIColor.redColor()
            }, completion: {(Bool) in
                
                // Set original background color.
                self.animateTimeRunningOutFade()
        })
    }

    
    /**
     Changes the color from red to the original background color.
    */
    func animateTimeRunningOutFade() {
        
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            // Set original background color.
            self.setColor(self.categoryTapped)
            
            }, completion: nil)
    }
    
    
    /**
     Animates the timer.
     */
    func animateTimer() {
        
        // Decrease the time.
        seconds -= 1
        minutes = 0
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }

}
