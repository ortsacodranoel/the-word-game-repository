//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Game Properties

    var game = Game()
    var answer = true
    var categoryTapped = Int()
    var teamTwoTurn = false
    var wordOnScreen = false
    var wordReset = true
    var wordRemoved = false

    /**
     Used to determine if a round is currently in progress.
     */
    var roundInProgress = false
    
    
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
    
    
    // MARK: - Button Properties
    
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Label Properties
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    
    /**
        Used to display the messages: '3', '2', '1', and 'Go!'.
    */
    @IBOutlet weak var countdownMsgLabel: UILabel!
    
    
    // MARK: - View Properties
    
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
    @IBOutlet weak var countdownMsgView: UIView!
    
    
    // MARK: - Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    
    // MARK: - Timer Properties
    var gameTimer = NSTimer()
    var countdownTimer = NSTimer()
    var seconds = 00
    var time : String = ""
    var timeIsUp = false
    var minutes = 1

    /**
        Used to store the values of the initial countdown and 'Go!' message when a player starts
        a new game.
    */
    var countdownNumber = 4
    
    // MARK: - Constraint Properties
    @IBOutlet weak var centerAlignWordContainer: NSLayoutConstraint!
    @IBOutlet weak var centerAlignMsgView: NSLayoutConstraint!
    
    // MARK: - Swipe Gesture Recognizer Properties
    let swipeRecognizer = UISwipeGestureRecognizer()
    var swipedRight = false
    var timesSwipedRight = 0

    
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Configure the Start button.
        self.startButton.layer.cornerRadius = 7
        self.startButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.startButton.layer.borderWidth = 3
        
        // Set initial value to display current team turn.
        self.updateTeamNameDisplayed()
        
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
        
        // Swipe Right - Gesture Recognizer.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        // Swipe Left - Gesture Recognizer.
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
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
        //self.countdownMsgView.alpha = 0
        
        self.timeUpView.alpha = 0
        self.timeUpView.userInteractionEnabled = false

        // Move countdownMsgView out of view.
        self.centerAlignMsgView.constant += view.bounds.width

        animationsStart()
    }
    
    /**
     
     */
    func currentRound() {

        self.startTimer()
        self.animateGameTimer()
        self.updateTeamNameDisplayed()
        self.updateTeamScoreDisplayed()
        self.endRound(40)
    }
    
    
    /**
     
     */
    func changeBackgroundColor() {
        UIView.animateWithDuration(0.4, delay:0.0, options: [], animations: {
          
            self.gameTimer.invalidate()
            self.view.backgroundColor = UIColor.greenColor()
            self.view.layoutIfNeeded()
            
            }, completion: { (bool) in
                self.resetRound()
        })
        
    }
    
    
    
    func resetRound() {
        
        UIView.animateWithDuration(0.4, delay: 1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            
            self.view.backgroundColor = self.colors[self.categoryTapped]

            }, completion: { (bool) in
                self.game.won = false
                self.resetTimer()
                self.game.resetGame()

                self.game.updateTeamTurn()
                self.updateTeamNameDisplayed()
                self.updateTeamScoreDisplayed()

                self.removeWord()
                self.animateTitleOnScreen()
                
                
        })

    }
    
    
    /**
    */
    func startTimer() {

        timeIsUp = false
        
        if self.seconds == 0 {
            self.seconds = 59
            self.minutes = 0
            let strMinutes = String(format: "%02d", self.minutes)
            let strSeconds = String(format: "%02d", self.seconds)
            self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
        }
        
        // Reset the value of the countdown number for the next time the countdown method runs.
        self.countdownNumber = 4
    }
    
    /**
    */
    func resetTimer() {
        self.roundInProgress = false
        self.timeIsUp = true
        self.gameTimer.invalidate()
        
        self.seconds = 00
        self.minutes = 1
        let strMinutes = String(format: "%02d", self.minutes)
        let strSeconds = String(format: "%02d", self.seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
    
    /**
    */
    func updateTeamScoreDisplayed() {
        self.teamOneScoreLabel.text = String(game.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(game.getTeamTwoScore())
    }
    
    
    /**
    */
    func endRound(time: Int) {
        if self.seconds == time {
            self.game.updateTeamTurn()
            self.updateTeamNameDisplayed()
            self.animateTimeRunningOutFadeIn()
            self.animateTimeIsUpMessageOnScreen()
            self.resetTimer()
            self.removeWord()
        }
    }


    
    
    
    
    // MARK: - Gesture Recognizers
    
    /**
     When the team know the answer they will swipe left. When they do not, they can pass on the 
     word by swiping right. Each team is limited to 2 passes per round.
    */
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right: // RIGHT SWIPE
                    if roundInProgress == true {
                    
                        // Animate word to the right offscreen and create a new word.
                        if wordOnScreen && timesSwipedRight < 2 {
                          
                            // Increase times swiped right.
                            timesSwipedRight += 1
                            
                            // Create and display new word.
                            animateNewWordRightSwipe()
                        } else {
                            animatePassMessage()
                    }
                }

                // LEFT swipe.
                case UISwipeGestureRecognizerDirection.Left:
                
                    // Check if round has started.
                    if self.roundInProgress == true {
                    
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
                    }
                
                default:
                    break
                }
        }
    }

    
    // MARK: - Button Actions
    
    /**
     Tapping the Start button calls the methods to remove the Start Button,
     the Categories Menu, and the current Team Title from the screen. It also 
     sets the initial value of the Timer laber to 59, and calls the timer method 
     to start counting down from 59.
    */
    @IBAction func startButtonTapped(sender: AnyObject) {
        // Reset right swipe count.
        self.timesSwipedRight = 0
        self.roundInProgress = true
        // Animate offscreen: startButtonView and menuView
        self.animateTitleOffScreen()
    }
    
    
    
    /**
        Run countdown timer.
    */
    func runCountdownTimer() {
        // Execute the countdownTimer.
        if !self.countdownTimer.valid {
            self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameViewController.animateCountdownTimer), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
        Run game timer.
    */
    func runGameTimer() {
        if !self.gameTimer.valid {
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.currentRound), userInfo:nil, repeats: true)
        }
    }
    
    /**
     When the Menu Button is tapped it calls the segue to unwind
     back to the initial categories screen.
     */
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    
    /**
        Updates the team title displayed based on whose turn it is.
    */
    func updateTeamNameDisplayed() {
        if game.teamOneIsActive {
            teamLabel.text = "Team One"
        } else {
            teamLabel.text = "Team Two"
        }
    }
    

    /**
     Sets the color of the background based on the category selected.
     
     - Parameter category: Int
     */
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }

    
    // MARK: - Initial Animations
    
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
        UIView.animateWithDuration(0.5, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.wordLabel.text = self.game.getWord(self.categoryTapped)
            self.wordContainerView.alpha = 1
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            self.wordOnScreen = true
            }, completion: {(bool) in
                self.repositionCountdownMsgView()
                self.runGameTimer()
        })
    }
    

    
    // MARK: - Swipe Based Animations
    
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
     Fade-out animation for...
     
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
            
            self.game.checkForWinner()
            
            
            }, completion: {(bool) in
                
                if self.game.won {
                    
                    print(self.game.winnerTitle)
                    self.wordLabel.text = "\(self.game.winnerTitle) wins!"
                    self.changeBackgroundColor()
                    
                } else {
                    self.wordLabel.text = self.game.getWord(self.categoryTapped)
                }
        })
        
        
        /**
        // Animates wordViewController to the middle of the screen.
        */
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
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: {(Bool) in
            self.wordLabel.text = self.game.getWord(self.categoryTapped)
        })
        
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    

    

    // MARK: - Animations (Fade-Out/off-screen)
    
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
     Animates menuView, startButton, and teamLabel to their initial positions on-screen.
    */
    func animateTitleOnScreen() {
        UIView.animateWithDuration(0.5, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                        self.menuView.userInteractionEnabled = true
                        self.menuView.alpha = 1
            }, completion: nil)

        UIView.animateWithDuration(0.5, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.startButton.userInteractionEnabled = true
            self.startButton.center.y -= self.view.bounds.height
            self.startButton.alpha = 1
            
            self.teamLabel.alpha = 1
            self.teamLabel.center.y += self.view.bounds.height
        }, completion: nil)
    }
    
    
    /**
     Animates Start, Team, and Menu off-screen.
     - Upon completion the animateCountdownFadeIn() method is executed.
     */
    func animateTitleOffScreen() {
        UIView.animateWithDuration(0.5, delay:0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 0.6,options: [], animations: {
            
                self.startButton.userInteractionEnabled = false
                self.startButton.center.y += self.view.bounds.height
                self.startButton.alpha = 0
            
                self.teamLabel.center.y -= self.view.bounds.height
                self.teamLabel.alpha = 0
            
                self.menuView.alpha = 0
                self.menuView.userInteractionEnabled = false

            }, completion: {(bool) in
                self.startCountdownMsgView()
                self.runCountdownTimer()
        })
    }
    

    // MARK: - Animations (Time)
    
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
     UIView.animateWithDuration(0.2, delay:1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.timeUpView.alpha = 0
            self.timeUpView.center.y -= self.view.bounds.height
        }, completion: { (bool) in
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
            }, completion: { (bool) in
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
    func animateGameTimer() {
        self.seconds -= 1
        self.minutes = 0
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }

    
    /**
     This method is called by the
    */
    func animateCountdownTimer() {
        if self.countdownNumber  > 1 {
            self.countdownNumber -= 1
            self.countdownMsgLabel.text = "\(self.countdownNumber)"
        } else {
            self.countdownMsgLabel.text = "Go!"
            self.countdownTimer.invalidate()
            self.countdownNumber = 4
        }
    }
    
    
    // MARK: - Animations (Pre-game countdown)
    
    
    /**
        Fade-in and centering of the countdownMsgView onto the screen. 
        A 4.0 seconds allows the label text within the view to display 
        '3','2','1','Go!' with sufficient time.
     */
    func startCountdownMsgView() {
        UIView.animateWithDuration(0.2, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations:{
            self.centerAlignMsgView.constant -= self.view.bounds.width
            self.countdownMsgView.alpha = 1
        }, completion: { (bool) in
                self.removeCountdownMsgView()
                self.animateInitialWord()
        })
    }
    
    /**
     Countdown Method
     
 
     */
    func removeCountdownMsgView() {
        UIView.animateWithDuration(0.2, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.centerAlignMsgView.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    
    /**
        Moves the countDownMsgView back to it's original position.
    */
    func repositionCountdownMsgView() {
         UIView.animateWithDuration(0.0, animations:  {
            self.countdownMsgLabel.text = ""
            self.centerAlignMsgView.constant += self.view.bounds.width + self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
}





//                // MARK: Check if there is a winner.
//
//                if self.game.won {
//                    if self.game.teamOneScore == 5 {
//                        self.wordLabel.text = "TEAM ONE WINS!"
//                        self.changeBackgroundColor()
//                    } else if self.game.teamTwoScore == 5 {
//                        self.wordLabel.text = "TEAM TWO WINS"
//                        self.changeBackgroundColor()
//                    }
//                } else {

