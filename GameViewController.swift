//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
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
    /// Used to determine if round is in progress.
    var roundInProgress = false
    
    

    
    @IBOutlet weak var teamOneScoreTitleView: UIView!
    @IBOutlet weak var teamOneScoreView: UIView!
    @IBOutlet weak var teamTwoScoreTitleView: UIView!
    @IBOutlet weak var teamTwoScoreView: UIView!
    
    @IBOutlet weak var timesUpView: UIView!
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var countdownMsgView: UIView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var wordContainerView: UIView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var wordLabel: UILabel!

    @IBOutlet weak var countdownMsgLabel: UILabel!
    
    @IBOutlet weak var passesLabel: UILabel!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    
    
    @IBOutlet weak var centerAlignWordContainer: NSLayoutConstraint!
    @IBOutlet weak var centerAlignMsgView: NSLayoutConstraint!
    
    @IBOutlet weak var centerAlignStartButton: NSLayoutConstraint!
    

    
    // MARK: - Button Properties

    @IBOutlet weak var startButton: UIButton!
    
    

    
    // MARK: - Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    
    // MARK: - Timer Properties
    var gameTimer = Timer()
    var countdownTimer = Timer()
    var seconds = 00
    var minutes = 1
    var time : String = ""
    var timeIsUp = false
    
    /**
     Used to store the values of the initial countdown and 'Go!' message when a player starts
     a new game.
     */
    var countdown = 4
    
    
    // MARK: - Swipe Gesture Recognizer Properties
    var swipedRight = false
    var timesSwipedRight = 0
    
    
    // MARK: - Audio Properties
    
    // Paths to sound effects.
    let soundEffectButtonTap = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    let soundEffectSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "swipeSoundEffect", ofType: "mp3")!)
    let soundEffectWinner = URL(fileURLWithPath: Bundle.main.path(forResource: "winner", ofType: "mp3")!)
    let soundEffectStartRound = URL(fileURLWithPath: Bundle.main.path(forResource: "initialCountdown", ofType: "mp3")!)
    let soundEffectEndRound = URL(fileURLWithPath: Bundle.main.path(forResource: "countdown", ofType: "mp3")!)
    
    /// Used for menu interactions sounds.
    var audioPlayerButtonTapSound = AVAudioPlayer()
    /// Used for sound effect when a word is swiped during the game.
    var audioPlayerSwipeSound = AVAudioPlayer()
    /// Used to play the sound effect when a team wins.
    var audioPlayerWinSound = AVAudioPlayer()
    /// Used to play sound effects before a game round begins.
    var audioPlayerRoundIsStartingSound = AVAudioPlayer()
    /// Used to play sound effects when the game timer is coming to an end.
    var audioPlayerRoundIsEndingSound = AVAudioPlayer()
    
    

    
    
    // MARK: - BUTTON METHODS
    
    /**
     Tapping the Start button calls the methods to remove the Start Button,
     the Categories Menu, and the current Team Title from the screen. It also
     sets the initial value of the Timer laber to 59, and calls the timer method
     to start counting down from 59.
     */
    @IBAction func startButtonTapped(_ sender: AnyObject) {
        self.audioPlayerButtonTapSound.play()
        self.audioPlayerRoundIsStartingSound.play()
        self.timesSwipedRight = 0
        self.animateMenusOffScreen()
    }
    
    
    /**
     When the Menu Button is tapped it calls the segue to unwind
     back to the initial categories screen.
     */
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    // MARK:- Init() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRightGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resetTimer()
        
        // Start button configuration.
        self.startButton.layer.cornerRadius = 7
        self.startButton.layer.borderColor = UIColor.white.cgColor
        self.startButton.layer.borderWidth = 3
        
        // Move Start button off screen.
        self.centerAlignStartButton.constant -= view.bounds.height
        
        
        
        
        self.loadSounds()
        self.setColor(categoryTapped)
        self.setTeamTurn()
        
        self.passesLabel.alpha = 0
        
        // Moves the word container to the right of the screen for initial animation.
        self.centerAlignWordContainer.constant += view.bounds.width
        self.timesUpView.alpha = 0
        
        self.centerAlignMsgView.constant += view.bounds.width
        
        self.teamOneScoreLabel.text = String(game.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(game.getTeamTwoScore())
        
        self.animationsStart()
    }
    
    
    
    // MARK: - SWIPE GESTURES
    /**
     When the team know the answer they will swipe left. When they do not, they can pass on the
     word by swiping right. Each team is limited to 2 passes per round.
     */
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if self.roundInProgress {
                    if game.teamOneIsActive {
                        self.audioPlayerSwipeSound.play()
                        game.teamOneScore += 1
                        teamOneScoreLabel.text = String(game.getTeamOneScore())
                        self.animateNewWordRightSwipe()
                    } else {
                        self.audioPlayerSwipeSound.play()
                        game.teamTwoScore += 1
                        teamTwoScoreLabel.text = String(game.getTeamTwoScore())
                        self.animateNewWordRightSwipe()
                    }
                }
            case UISwipeGestureRecognizerDirection.left:
                if self.roundInProgress {
                    if  self.wordOnScreen && self.timesSwipedRight < 2 {
                        self.audioPlayerSwipeSound.play()
                        self.timesSwipedRight += 1
                        self.animateNewWordLeftSwipe()
                    } else {
                        animatePassMessage()
                    }
                }
            default:
                break
            }
        }
    }
    
    
    
    
    
    
    /// Updates the team name displayed for each turn.
    func setTeamTurn() {
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
    func setColor(_ category: Int) {
        self.view.backgroundColor = Game.sharedGameInstance.colors[category]
    }
    
    
    // MARK: - TIMER METHODS
    
    /// Countdown that appears before the game starts.
    func runCountdownTimer() {
        self.view.isUserInteractionEnabled = false
        if !self.countdownTimer.isValid {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameViewController.startCountdown), userInfo:nil, repeats: true)
        }
    }
    
    
    /// Main timer used in the game.
    func runGameTimer() {
        
        self.repositionCountdownMsgView()
        
        if !self.gameTimer.isValid {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.startRound), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
     This method is used to initialize the timer display to start the game.
     It changes `01:00` to `00:59`, and notifies that the game round has started
     by setting timeIsUp to `false`.
     */
    func prepareGameTimer() {
        timeIsUp = false
        if self.seconds == 0 {
            self.seconds = 60
            self.minutes = 0
            let strMinutes = String(format: "%1d", self.minutes)
            let strSeconds = String(format: "%02d", self.seconds)
            self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
        }
        
        self.countdown = 4
    }
    
    
    
    /// Animates main game timer.
    func animateGameTimer() {
        self.seconds -= 1
        self.minutes = 0
        let strMinutes = String(format: "%1d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
    /**
     */
    func resetTimer() {
        self.roundInProgress = false
        self.timeIsUp = true
        self.gameTimer.invalidate()
        self.seconds = 00
        self.minutes = 1
        let strMinutes = String(format: "%1d", self.minutes)
        let strSeconds = String(format: "%02d", self.seconds)
        self.timeLeftLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
    
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - GAMEPLAY
    
    func startRound() {
        self.setTeamTurn()
        self.prepareGameTimer()
        self.animateGameTimer()
        self.updateScore()
        self.endRound(50)
    }
    
    
    /**
     Sets a new word to display based on the selected category. Animates that word onto
     the screen from the left side of the view, and sets`wordOnScreen` equal to true.
     */
    func animateInitialWord() {
        UIView.animate(withDuration: 0.2, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.wordLabel.text = self.game.getWord(self.categoryTapped)
            self.wordContainerView.alpha = 1
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: {(bool) in
                self.runGameTimer()
        })
    }
    
    /// Changes the score labels content depending on the current score.
    func updateScore() {
        self.teamOneScoreLabel.text = String(game.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(game.getTeamTwoScore())
    }
    
    
    func resetRound(_ time: Double ) {
        UIView.animate(withDuration: 0.4, delay: time, usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.view.backgroundColor = Game.sharedGameInstance.colors[self.categoryTapped]
            }, completion: { (bool) in
                self.mainView.backgroundColor = UIColor.red
                self.game.won = false
                self.audioPlayerRoundIsEndingSound.prepareToPlay()
                self.resetTimer()
                self.game.resetGame()
                self.game.updateTeamTurn()
                self.setTeamTurn()
                self.updateScore()
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
    func endRound(_ time: Int) {
        if self.seconds == 53 {
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.play()
            self.animateBackgroundColorFadeIn()
        } else if self.seconds == time && self.game.won == false { // If time is up  and nobody won the game.
            
            self.game.updateTeamTurn()
            self.setTeamTurn()
            self.animateTimeIsUpMessageOnScreen()
            self.resetTimer()
            self.removeWord()
            
            
        }
    }
    
    func animateSegueToSummary() {
        // Segue to summary.
        self.performSegue(withIdentifier: "segueToWordSummary", sender: self)
    }
    
    
    
    // MARK: - Animations
    
    /**
     Used to animate all views when the GameViewController first loads. The animations
     occur with a minor difference in execution time in order to create an effect.
     */
    func animationsStart() {
        UIView.animate(withDuration: 0.4, delay: 0.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScoreTitleView.alpha = 1
            self.teamOneScoreTitleView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScoreView.alpha = 1
            self.teamOneScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScoreTitleView.alpha = 1
            self.teamTwoScoreTitleView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScoreView.alpha = 1
            self.teamTwoScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.menuView.alpha = 1
            self.menuView.center.y += self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamView.alpha = 1
            self.teamView.center.y += self.view.bounds.height
          
            self.startButton.alpha = 1
            //self.startButton.center.y += self.view.bounds.height
            //self.centerAlignStartButton.constant
            
            }, completion: nil)
    }
    
    
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - Swipe Based Animations
    
    /**
     Animates the wordViewContainer left off-screen, followed by an animation of the container
     back to its original position to the right off-screen, finalizing by animating a new word
     to the middle of the screen. It also calls the .getWord() method to create the new word
     that is animated onto the screen.
     */
    
    func animateNewWordLeftSwipe() {
        
        // Used to store the correct words.
        let currentWord = self.wordLabel.text
        Game.sharedGameInstance.missedWordsArray.append(currentWord!)
        
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // Moves the word that is currently on the screen off-screen left.
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        UIView.animate(withDuration: 0.0, delay:0.4, options: [], animations: {
            // Moves the word that was just moved left off-screen all the way back to the right off-screen.
            self.centerAlignWordContainer.constant += self.view.bounds.width + self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: { (Bool) in
                self.wordLabel.text = self.game.getWord(self.categoryTapped)
        })
        
        // Animates the word back from the right off-screen, to the middle.
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    /**
     The initial word animation moves the wordContainerView into view from the left side of the screen.
     */
    func animateNewWordRightSwipe() {
        
        let currentWord = self.wordLabel.text
        Game.sharedGameInstance.correctWordsArray.append(currentWord!)
        
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.centerAlignWordContainer.constant += self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            
            // Check to see if game has been won.
            self.game.checkForWinner()
            
            }, completion: {(Bool) in
                if self.game.won {
                    self.animateGameWin()
                } else {
                    self.wordLabel.text = self.game.getWord(self.categoryTapped)
                }
        })
        
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
            self.centerAlignWordContainer.constant -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    
    
    /**
     Only two passes are allowed per game. This method fades in the 'Only 2 Passes' message with a duration of 0.5 seconds.
     */
    func animatePassMessage() {
        UIView.animate(withDuration: 0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.passesLabel.alpha = 1
            }, completion: {(bool) in
                self.animatePassMessageFadeOut()
        })
    }
    
    
    func animatePassMessageFadeOut(){
        UIView.animate(withDuration: 0.5, delay:1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.passesLabel.alpha = 0
            }, completion: nil)
    }
    
    
    
    
    /**
     When a team wins the game this method...
     */
    func animateGameWin() {
        
        if self.game.won {
            
            self.gameTimer.invalidate()
            self.audioPlayerRoundIsEndingSound.pause()
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            self.mainView.alpha = 0
            self.audioPlayerWinSound.play()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = UIColor.green
                self.view.layoutIfNeeded()
                }, completion: { (bool) in
                    self.resetRound(2.0)
            })
            
            self.wordLabel.text = "\(self.game.winnerTitle) Wins!"
            
        } else {
            
            // Since there isn't a winner, get a new word.
            self.wordLabel.text = self.game.getWord(self.categoryTapped)
        }
    }
    
    
    
    // MARK: - Animations (Fade-Out/off-screen)
    
    
    
    /**
     Animates menuView, startButton, and teamLabel to their initial positions on-screen.
     */
    func animateTitleOnScreen() {
        UIView.animate(withDuration: 0.5, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.menuView.isUserInteractionEnabled = true
            self.menuView.alpha = 1
            }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.startButton.isUserInteractionEnabled = true
           // self.startButton.center.y -= self.view.bounds.height
            self.startButton.alpha = 1
            
            self.teamLabel.alpha = 1
            self.teamLabel.center.y += self.view.bounds.height
            }, completion: nil)
    }
    
    
    /**
     Animates Start, Team, and Menu off-screen.
     - Upon completion the animateCountdownFadeIn() method is executed.
     */
    func animateMenusOffScreen() {
        UIView.animate(withDuration: 0.5, delay:0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 0.6,options: [], animations: {
            
            self.startButton.isUserInteractionEnabled = false
           // self.startButton.center.y += self.view.bounds.height
            self.startButton.alpha = 0
            
            self.teamLabel.center.y -= self.view.bounds.height
            self.teamLabel.alpha = 0
            
            self.menuView.alpha = 0
            self.menuView.isUserInteractionEnabled = false
            
            }, completion: {(bool) in
                self.presentCountdownView()
                self.runCountdownTimer()
        })
    }
    
    // TODO: -
    /**
     Used to remove the current word off the screen to the right.
     */
    func removeWord() {
        
        if self.game.won {
            UIView.animate(withDuration: 0.4, delay:0.0, options: [], animations: {
                self.centerAlignWordContainer.constant += self.view.bounds.width
                self.wordContainerView.alpha = 1
                self.view.layoutIfNeeded()
                },  completion: { (bool) in
                    self.resetRound(0)
            })
        } else {
            
            UIView.animate(withDuration: 0.4, animations: {
                // Move word to the right of the screen.
                self.centerAlignWordContainer.constant += self.view.bounds.width
                self.wordContainerView.alpha = 1
                self.view.layoutIfNeeded()
                
                }, completion:nil)
        }
    }
    
    
    func animateSummaryViewController() {
        UIView.animate(withDuration: 1.0, delay:4.0, options: [], animations: {
            self.performSegue(withIdentifier: "segueToWordSummary", sender: self)
            }, completion: nil)
    }
    
    
    func removeWinMessage() {
        self.centerAlignWordContainer.constant += self.view.bounds.width
        self.wordContainerView.alpha = 1
    }
    
    
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - COUNTDOWN ANIMATIONS
    
    /**
     Used to create the message "3,2,1...Go!" that informs players that
     a round will begin shortly. Once the countdown animations have concluded,
     the method invalidates its timer and resets the 'countdown' variable
     so that it can be used in new round. Prior to exiting the method all
     user interactions a re-enabled.
     */
    func startCountdown() {
        if self.countdown  > 1 {
            self.countdown -= 1
            self.countdownMsgLabel.text = "\(self.countdown)"
        } else {
            self.view.isUserInteractionEnabled = true
            self.wordOnScreen = true
            self.roundInProgress = true
            self.countdownMsgLabel.text = "Go!"
            self.countdownTimer.invalidate()
            self.countdown = 4
        }
    }
    
    
    /**
     Fade-in and centering of the countdownMsgView onto the screen.
     A 4.0 seconds allows the label text within the view to display
     '3','2','1','Go!' with sufficient time.
     */
    func presentCountdownView() {
        UIView.animate(withDuration: 0.2, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations:{
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
        UIView.animate(withDuration: 0.2, delay:2.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.centerAlignMsgView.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    /**
     Moves the countDownMsgView back to it's original position.
     */
    func repositionCountdownMsgView() {
        self.countdownMsgLabel.text = ""
        self.centerAlignMsgView.constant += self.view.bounds.width + self.view.bounds.width
    }
    
    
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - TIME UP ANIMATIONS
    
    /// Animates 'timeUpView'from the top of the screen with the message `Time's Up!`.
    func animateTimeIsUpMessageOnScreen() {
        if self.game.won == false {
            UIView.animate(withDuration: 0.2, delay:0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.timesUpView.alpha = 1
                self.timesUpView.center.y += self.view.bounds.height
                }, completion: { (bool) in
                    self.animateTimeIsUpMessageOffScreen()
            })
        }
    }
    
    /// Animates timeUpView with the message `Time's up!` off-screen.
    func animateTimeIsUpMessageOffScreen() {
        UIView.animate(withDuration: 0.2, delay:1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.timesUpView.alpha = 0
            self.timesUpView.center.y -= self.view.bounds.height
            }, completion: { (bool) in
                //self.animateTitleOnScreen()
                self.animateSummaryViewController()
                
        })
    }
    
    /// Animates the alpha value of the `backgroundView` to display a red screen when time runs out.
    func animateBackgroundColorFadeIn() {
        if self.game.won == false {
            UIView.animate(withDuration: 4.5, animations: {
                self.mainView.alpha = 1
                }, completion: { (bool) in
                    self.animateBackgroundColorFadeOut()
            })
        }
    }
    
    /// Animates `backgroundView` back to full transparency.
    func animateBackgroundColorFadeOut() {
        UIView.animate(withDuration: 1.0, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.mainView.alpha = 0
            }, completion: nil)
    }


    
    // MARK: - Audio
    
    /// Configures the AVAudioPlayers with their respective sound files and prepares them to be played.
    func loadSounds() {
        do {
            self.audioPlayerButtonTapSound = try AVAudioPlayer(contentsOf: self.soundEffectButtonTap, fileTypeHint: "wav")
            self.audioPlayerWinSound = try AVAudioPlayer(contentsOf: self.soundEffectWinner,fileTypeHint: "mp3")
            self.audioPlayerSwipeSound = try AVAudioPlayer(contentsOf: self.soundEffectSwipe, fileTypeHint: "wav")
            self.audioPlayerRoundIsStartingSound = try AVAudioPlayer(contentsOf: self.soundEffectStartRound, fileTypeHint: "mp3")
            self.audioPlayerRoundIsEndingSound = try AVAudioPlayer(contentsOf: self.soundEffectEndRound, fileTypeHint: "mp3")
            self.audioPlayerButtonTapSound.prepareToPlay()
            self.audioPlayerWinSound.prepareToPlay()
            self.audioPlayerSwipeSound.prepareToPlay()
            self.audioPlayerRoundIsStartingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
        } catch {
            print("Error: unable to find sound files.")
        }
    }


}
