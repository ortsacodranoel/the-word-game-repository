//
//  GameViewController.swift
//  testing-animations
//
//  Created by Leo on 7/2/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    // MARK: - Game Properties
    var game = Game()
    var categoryTapped = Int()
    var wordOnScreen = false
    var wordRemoved = false
    
    /**
     Used to determine if a round is currently in progress.
     */
    var roundInProgress = false
    
    
    // MARK: - Data
    let colors  = [
        UIColor(red: 147/255, green: 126/255, blue: 211/225, alpha: 1),             // Jesus
        UIColor(red: 62/255, green: 166/255, blue: 182/225, alpha: 1),              // People
        UIColor(red: 202/255, green: 115/255, blue: 99/225, alpha: 1),              // Places
        UIColor(red: 215/255, green: 184/255, blue: 136/225, alpha: 1),             // Sunday School
        UIColor(red: 55/255, green: 98/255, blue: 160/225, alpha: 1),               // Concordance
        UIColor(red: 163/255, green: 56/255, blue: 120/225, alpha: 1),              // Famous Christians
        UIColor(red: 199/255, green: 176/255, blue: 87/225, alpha: 1),              // Worship
        UIColor(red: 159/255, green: 200/255, blue: 223/225, alpha: 1),             // Books and Movies
        UIColor(red: 48/255, green: 142/255, blue: 145/225, alpha: 1),              // Feasts
        UIColor(red: 178/255, green: 215/255, blue: 255/225, alpha: 1),             // Relics and Saints
        UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),               // Revelation
        UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),             // Angels
        UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),             // Doctrine
        UIColor(red: 152/255, green: 221/255, blue: 217/225, alpha: 1),             // Sins
        UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1)                // Commands
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
    @IBOutlet weak var backgroundView: UIView!
    
    
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
    var swipedRight = false
    var timesSwipedRight = 0

    
    // MARK: - Audio Properties & Methods
    
    // Paths to sound effects.
    let soundEffectButtonTap = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ButtonTapped", ofType: "wav")!)
    let soundEffectSwipe = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Swipe", ofType: "wav")!)
    let soundEffectWinner = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("winner", ofType: "mp3")!)
    let soundEffectStartRound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("initialCountdown", ofType: "mp3")!)
    let soundEffectEndRound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("countdown", ofType: "mp3")!)
    
    /// Used for menu interactions sounds.
    var audioPlayerButtonTapSound = AVAudioPlayer()
    /// Used for sound effect when a word is swiped during the game.
    var audioPlayerSwipeSound = AVAudioPlayer()
    /// Used to play the sound effect when a team wins.
    var audioPlayerWinSound = AVAudioPlayer()
    /// Used to play sound effects before a game round begins.
    var audioPlayerStartRoundSound = AVAudioPlayer()
    /// Used to play sound effects when the game timer is coming to an end.
    var audioPlayerEndRoundSound = AVAudioPlayer()
    
    
    /// Configures the AVAudioPlayers with their respective sound files and prepares them to be played.
    func loadSounds() {
        do {
            self.audioPlayerButtonTapSound = try AVAudioPlayer(contentsOfURL: self.soundEffectButtonTap, fileTypeHint: "wav")
            self.audioPlayerWinSound = try AVAudioPlayer(contentsOfURL: self.soundEffectWinner,fileTypeHint: "mp3")
            self.audioPlayerSwipeSound = try AVAudioPlayer(contentsOfURL: self.soundEffectSwipe, fileTypeHint: "wav")
            self.audioPlayerStartRoundSound = try AVAudioPlayer(contentsOfURL: self.soundEffectStartRound, fileTypeHint: "mp3")
            self.audioPlayerEndRoundSound = try AVAudioPlayer(contentsOfURL: self.soundEffectEndRound, fileTypeHint: "mp3")
            self.audioPlayerButtonTapSound.prepareToPlay()
            self.audioPlayerWinSound.prepareToPlay()
            self.audioPlayerSwipeSound.prepareToPlay()
            self.audioPlayerStartRoundSound.prepareToPlay()
            self.audioPlayerEndRoundSound.prepareToPlay()
        } catch {
            print("Error: unable to find sound files.")
        }
    }
    
    
    // MARK: - BUTTON METHODS
    
    /**
         Tapping the Start button calls the methods to remove the Start Button,
         the Categories Menu, and the current Team Title from the screen. It also
         sets the initial value of the Timer laber to 59, and calls the timer method
         to start counting down from 59.
     */
    @IBAction func startButtonTapped(sender: AnyObject) {

        // Sound effects.
        self.audioPlayerButtonTapSound.play()
        self.audioPlayerStartRoundSound.play()
        
        // Reset right swipe count.
        self.timesSwipedRight = 0
        
        // Notify round started.
        self.roundInProgress = true
      
        // Animate offscreen: startButtonView and menuView
        self.animateTitleOffScreen()
    }


    /**
        When the Menu Button is tapped it calls the segue to unwind
        back to the initial categories screen.
     */
    @IBAction func menuButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    

    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSounds()
        
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

    /// Updates the team name displayed for each turn.
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

    
    
    
    
    
    
    // MARK: - Timer Methods

    /**
        Used for the initial countdown before the game starts.
     */
    func runPregameTimer() {

        // Disable gesture recognizer until game starts.
        self.view.userInteractionEnabled = false
        
        
        // Execute the countdownTimer.
        if !self.countdownTimer.valid {
            self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameViewController.animateCountdownTimer), userInfo:nil, repeats: true)
        }
    }
    
    func runGameTimer() {
        if !self.gameTimer.valid {
            self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameViewController.currentRound), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
        This method is used to initialize the timer display to start the game. 
        It changes `01:00` to `00:59`, and notifies that the game round has started
        by setting timeIsUp to `false`.
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
    
    
    
    // MARK: - Gameplay Methods
    
    /**
     
     */
    func currentRound() {
        self.startTimer()
        self.animateGameTimer()
        self.updateTeamNameDisplayed()
        self.updateTeamScoreDisplayed()
        self.endRound(50)
    }
    
    
    
    /**
        Sets a new word to display based on the selected category. Animates that word onto 
        the screen from the left side of the view, and sets`wordOnScreen` equal to true.
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
    
    

    
    
    
    /**
     
     */
    func updateTeamScoreDisplayed() {
        self.teamOneScoreLabel.text = String(game.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(game.getTeamTwoScore())
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
        Used to run all methods that prepare the next round of the game. 
        When the time reaches 3 seconds left, the method runs the alert 
        sound.
     
        Parameters time: Int - used to indicate at what time the timer should stop.
    */
    func endRound(time: Int) {
        
        // 3 seconds before the game ends:
        if self.seconds == 53 {
            
            self.animateTimeRunningOutFadeIn()
            
            if self.game.won == false {
                self.audioPlayerEndRoundSound.play()
            } else if self.game.won == true {
                self.audioPlayerEndRoundSound.stop()
            }
        }
        // The game should end:
        if self.seconds == time {
            self.game.updateTeamTurn()
            self.updateTeamNameDisplayed()

            self.animateTimeIsUpMessageOnScreen()
            self.resetTimer()
            self.removeWord()
        }
    }



    // MARK: - Swipe Gesture Recognizers
    
    
    /**
     When the team know the answer they will swipe left. When they do not, they can pass on the 
     word by swiping right. Each team is limited to 2 passes per round.
    */
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right: // RIGHT SWIPE
                    if self.roundInProgress == true {
                        
                        self.audioPlayerSwipeSound.prepareToPlay()
                        
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
                    if wordOnScreen == true {
                        // Check if round has started.
                        if self.roundInProgress == true {
                            self.audioPlayerSwipeSound.prepareToPlay()
                            
                            // Check if team one is active and that time is still valid.
                            if game.teamOneIsActive && timeIsUp == false {
                                
                                // Increment Team 1 score.
                                game.teamOneScore += 1
                                // Update Team 1 score text.
                                teamOneScoreLabel.text = String(game.getTeamOneScore())
                                
                                // Create new word.
                                self.animateNewWordLeftSwipe()
                                
                            } else if timeIsUp == false {
                                // Increment Team 2 score.
                                game.teamTwoScore += 1
                                // Update score label.
                                teamTwoScoreLabel.text = String(game.getTeamTwoScore())
                                // Create new word.
                                animateNewWordLeftSwipe()
                            }
                    }
                    
                }
                
            default:
                    break
                }
        }
    }

    

    
    // MARK: - Animations
    
    /**
        Used to animate all views when the GameViewController first loads. The animations
        occur with a minor difference in execution time in order to create an effect.
    */
    func animationsStart() {
        UIView.animateWithDuration(0.4, delay: 0.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScoreTitleView.alpha = 1
            self.teamOneScoreTitleView.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScore.alpha = 1
            self.teamOneScore.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScoreTitleView.alpha = 1
            self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScore.alpha = 1
            self.teamTwoScore.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.menuView.alpha = 1
            self.menuView.center.y += self.view.bounds.height
        }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.TeamTitleView.alpha = 1
            self.TeamTitleView.center.y += self.view.bounds.height
            self.startButton.alpha = 1
            self.startButton.center.y -= self.view.bounds.height
        }, completion: nil)
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
        
        self.audioPlayerSwipeSound.play()
        
        // Animate `wordContainerView` left off-screen.
        UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    
        UIView.animateWithDuration(0.0, delay:0.3, options: [], animations: {
            self.centerAlignWordContainer.constant += self.view.bounds.width + self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            self.game.checkForWinner()
        }, completion: {(bool) in
            self.animateGameWin()
        })
        
        // Animate `wordContainerView` to the center.
        UIView.animateWithDuration(0.4, delay:0.2, options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }


    
    func animateGameWin() {
        if self.game.won {
            self.audioPlayerEndRoundSound.stop()
            self.audioPlayerWinSound.play()
            self.wordLabel.text = "\(self.game.winnerTitle) Wins!"
            self.changeBackgroundColor()
        } else {
            self.wordLabel.text = self.game.getWord(self.categoryTapped)
        }
    }
    
    
    
    
    
    /**
     The initial word animation moves the wordContainerView into view from the left side
     of the screen.
     */
    func animateNewWordRightSwipe() {
        
        self.audioPlayerSwipeSound.play()
  
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
                self.runPregameTimer()
        })
    }
    

    // MARK: - Animations (Time)
    

    /// Animates TimeUpView on-screen.
    func animateTimeIsUpMessageOnScreen() {
        
        // If nobody won:
        if self.game.won == false {
            UIView.animateWithDuration(0.2, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                    self.timeUpView.alpha = 1
                    self.timeUpView.center.y += self.view.bounds.height
            }, completion: { (bool) in
                self.animateTimeIsUpMessageOffScreen()
            })
        }
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
        if self.game.won == false {
            UIView.animateWithDuration(4.0, animations: {
                self.backgroundView.alpha = 1
            }, completion: { (bool) in
                // Fade out
                // Set original background color.
                self.animateTimeRunningOutFade()
            })
        }
    }
    
    
    /// Changes the color from red to the original background color.
    func animateTimeRunningOutFade() {
        UIView.animateWithDuration(1.0, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.backgroundView.alpha = 0
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
        Used to count down from 3 to 1 and display "Go!" prior to the game
        round start.
    */
    func animateCountdownTimer() {
        if self.countdownNumber  > 1 {
            self.countdownNumber -= 1
            self.countdownMsgLabel.text = "\(self.countdownNumber)"
        } else {
            self.countdownMsgLabel.text = "Go!"
            self.countdownTimer.invalidate()
            self.countdownNumber = 4
        
            self.view.userInteractionEnabled = true
            
        }
    }
    
    
    // MARK: - PreGame Countdown Animations
    
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
        Used to remove the view for the countdown animations that take place prior
        to the game starting.
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
