/*
    FIX: 
        - gameBegan variable change to false once game ends.
        -
        -
 
*/


import UIKit
import AVFoundation

class GameViewController: UIViewController {

    //MARK:- General properties
    var categoryTapped = Int()
    let UP = "UP"
    let DOWN = "DOWN"
    let OUT = "OUT"
    let IN = "IN"
    /// Used to store the value for the initial countdown.
    var countdown = 4
    ///
    var wordOnScreen = false
    ///
    var wordRemoved = false
    /// Used to determine if round is in progress.
    var roundInProgress = false

    //MARK: - Views
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var teamOneView: UIView!
    @IBOutlet weak var teamOneScoreView: UIView!
    @IBOutlet weak var teamTwoView: UIView!
    @IBOutlet weak var teamTwoScoreView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var teamTurnView: UIView!
    @IBOutlet weak var wordContainerView: UIView!
    @IBOutlet weak var timesUpView: UIView!
    /// Used when timer is running out.
    @IBOutlet weak var redBackgroundView: UIView!
    
    
    
    
    //MARK:- Labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var teamTurnLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    
    
    
    // MARK: - Transition Managers
    let transitionManager = TransitionManager()

    
    //MARK:- Buttons
    @IBOutlet weak var startButton: UIButton!
    
    //MARK:- Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    //MARK:- Timer Properties
    var gameTimer = Timer()
    var countdownTimer = Timer()
    var segueDelayTimer = Timer()
    /// Used to animate Time's Up prior to summary screen.
    var timesUpTimer = Timer()
    
    var seconds = 00
    var minutes = 1
    var time = ""
    var timeIsUp = false
    
    
    //MARK:- Swipe Gesture Recognizer Properties
    var swipedRight = false
    var timesSwipedRight = 0

    
    
    // Paths to sound effects.
    let soundEffectButtonTap = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    let soundEffectSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "swipeSoundEffect", ofType: "mp3")!)
    let soundEffectWinner = URL(fileURLWithPath: Bundle.main.path(forResource: "winner", ofType: "mp3")!)
    let soundEffectStartRound = URL(fileURLWithPath: Bundle.main.path(forResource: "initialCountdown", ofType: "mp3")!)
    let soundEffectEndRound = URL(fileURLWithPath: Bundle.main.path(forResource: "countdown", ofType: "mp3")!)
    let soundEffectCorrectSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "correctSwipe", ofType: "mp3")!)
    let soundEffectWrongSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
    
    
    
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
    /// Used to play the correct swipe.
    var audioPlayerCorrectSwipe = AVAudioPlayer()
    /// Used to play the missed swipe.
    var audioPlayerWrondSwipe = AVAudioPlayer()
    
    
    
    // View centers.
    var menuButtonCenter:CGPoint!
    var timerButtonCenter:CGPoint!
    var startButtonCenter:CGPoint!
    var teamTurnCenter:CGPoint!
    var wordContainerCenter:CGPoint!
    var timesUpCenter:CGPoint!
    
    
    
    // Used to test celebration screen. 
    var gameWon = false
    
    
    
    
    
    
    
    // MARK:- VIEW METHODS
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
        super.didReceiveMemoryWarning() }


    /**
     - Get center of menuButtonView
     - Get center of
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Get centers of the views.
        menuButtonCenter = self.menuButtonView.center
        timerButtonCenter = self.timerView.center
        startButtonCenter = self.startButtonView.center
        teamTurnCenter = self.teamTurnView.center
        wordContainerCenter = self.wordContainerView.center
        timesUpCenter = self.timesUpView.center
        
        self.resetTimer()
        self.setTeamTurn()
        self.updateScore()
        self.setColorForViewBackground()
        self.configureViewStyles()
        self.configureLabelContent()
        self.loadSounds()

        // ANIMATION: Fade out `Time's Up` message off the screen so it's not seen during the game.
        self.timesUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: teamOneView up (-)
            self.teamOneView.center.y -= self.view.bounds.height
            }, completion:nil)
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: teamOneScore up (-)
            self.teamOneScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: teamTwoView up (-)
            self.teamTwoView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: teamTwoScore (-)
            self.teamTwoScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: menuBtn animation
            self.menuButtonView.center.y += self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: timerView animate down (+)
            self.timerView.center.y += self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: teamTurn animation
            self.teamTurnView.center.y += self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.9, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // ONSCREEN: startBtn animation
            self.startButtonView.center.y -= self.view.bounds.height
            }, completion: nil)
        
        
        self.teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
        

    }
    
    
    
    // MARK: - Audio
    
    /// Configures the AVAudioPlayers with their respective sound files and prepares them to be played.
    func loadSounds() {
        do {
            
            // Configure Audioplayers.
            self.audioPlayerButtonTapSound = try AVAudioPlayer(contentsOf: self.soundEffectButtonTap, fileTypeHint: "wav")
            self.audioPlayerWinSound = try AVAudioPlayer(contentsOf: self.soundEffectWinner,fileTypeHint: "mp3")
            self.audioPlayerSwipeSound = try AVAudioPlayer(contentsOf: self.soundEffectSwipe, fileTypeHint: "wav")
            self.audioPlayerRoundIsStartingSound = try AVAudioPlayer(contentsOf: self.soundEffectStartRound, fileTypeHint: "mp3")
            self.audioPlayerRoundIsEndingSound = try AVAudioPlayer(contentsOf: self.soundEffectEndRound, fileTypeHint: "mp3")
            self.audioPlayerCorrectSwipe = try AVAudioPlayer(contentsOf: self.soundEffectCorrectSwipe, fileTypeHint: "mp3")
            self.audioPlayerWrondSwipe = try AVAudioPlayer(contentsOf: self.soundEffectWrongSwipe, fileTypeHint: "mp3")
            
            
            // Prepare to play.
            self.audioPlayerButtonTapSound.prepareToPlay()
            self.audioPlayerWinSound.prepareToPlay()
            self.audioPlayerSwipeSound.prepareToPlay()
            self.audioPlayerRoundIsStartingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            // Swipes
            self.audioPlayerCorrectSwipe.prepareToPlay()
            self.audioPlayerWrondSwipe.prepareToPlay()
        
        } catch {
          
            print("Error: unable to find sound files.")
            
        }
    }
    
    

    
    
    
    // MARK:- startButtonTouchUpInside()
    /// Animates menus off-screen and starts game.
    @IBAction func startButtonTouchUpInside(_ sender: AnyObject) {
        
        self.audioPlayerButtonTapSound.play()
        self.audioPlayerRoundIsStartingSound.play()
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: wordContainerView animate (invisible)
            self.wordContainerView.center.x += self.view.bounds.width
            }, completion: nil )
        
        // TIME IS UP OFF SCREEN ANIMATE
        UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: Time's Up View off the screen to the top.
            self.timesUpView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: startBtn animate down (+).
            self.startButtonView.center.y += self.view.bounds.height
            // OFFSCREEN: teamTurnView animate up (-).
            self.teamTurnView.center.y -= self.view.bounds.height
            }, completion: nil )
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: menuBtn animate up (-).
            self.menuButtonView.center.y -= self.view.bounds.height
            }, completion: nil )
        self.runCountdownTimer()
        

        self.timesSwipedRight = 0
        
    }
    
    
    // MARK:- unwindToGame()
    /// Used to execute something when the view returns from the summary screen.
    @IBAction func unwindToGame(_ segue: UIStoryboardSegue){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                
                // OFFSCREEN: wordContainerView animate (invisible)
                self.wordContainerView.center.x -= self.view.bounds.width
                }, completion: nil )

            self.startButtonView.center.y -= self.view.bounds.height
            self.teamTurnView.center.y += self.view.bounds.height
        }, completion: nil )
        
        // timerView ANIMATION: down to it's original position.
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.timerView.center.y += self.view.bounds.height
            }, completion: nil )

        // Animate the menu back to it's original position.
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.menuButtonView.center.y += self.view.bounds.height
            },completion:nil)

        // Clear the words from the arrays.
        Game.sharedGameInstance.correctWordsArray = []
        Game.sharedGameInstance.missedWordsArray = []
    }
    


    @IBAction func menuTapped(_ sender: AnyObject) {
        // Audio tap sound.
        self.audioPlayerButtonTapSound.play()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    
    

    
    /**
    The method is used to execute actions pertaining to the end of a game round.
 
    - Alert sounds are played when the `gameTimer` reaches 3s left.
 
    - The background color fades to red to indicate time running out.
 
    - Updates the team turn.
 
    - Sets the team turn label.
 
    - Animates `Time's Up' onto the screen.
 
    - Executes segue to summary screen.

    - Parameter time: used to indicate at what time the timer should stop.
     */
    func endRound(_ time: Int) {
        if self.seconds == 43 {
      
            // Play sounds alerting round coming to an end.
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.play()
            
            
            // Red background color fade-in.
            UIView.animate(withDuration: 3.0, animations: { () -> Void in
                // Fade-in redBackgroundColor.
                self.redBackgroundView.alpha = 1
            })
         
            // If time is up and nobody won the game.
        } else if self.seconds == time && Game.sharedGameInstance.won == false {

            Game.sharedGameInstance.updateTeamTurn()
            self.setTeamTurn()
            
            // Animate the 'Time's Up' back onto the screen.
            UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
             //   print(self.timesUpView.center.y)
             //   print("Animating timesUpView")
                self.timesUpView.alpha = 1
                self.timesUpView.center.y += self.view.bounds.height
                }, completion: nil)
        
            // Change the color of the screen back to original.
            UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                self.setColorForViewBackground()
                }, completion: nil)
                
            // Move the 'gameTimer' up.
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    self.timerView.center.y -= self.view.bounds.height
                }, completion: nil)
            

            self.timesUpTimer.fire()
            
            // ANIMATION: Time's Up - Move UP.
            // Segue to the summary screen after 2.5 seconds.
            if !self.timesUpTimer.isValid {
                self.timesUpTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(GameViewController.animateTimesUpOffScreen), userInfo:nil, repeats: false)
            }
            

            // Reset to `1:00`.
            self.resetTimer()
            
            
            // Remove the current word displayed on the screen.
            self.removeWord()
            
            // Segue to the summary screen after 2.5 seconds.
            if !self.segueDelayTimer.isValid {
                self.segueDelayTimer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(GameViewController.displayWordSummaryScreen), userInfo:nil, repeats: false)
            }
        }
    }

    
    func resetRound(_ time: Double ) {
        UIView.animate(withDuration: 0.4, delay: time, usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
           
            self.view.backgroundColor = Game.sharedGameInstance.colors[self.categoryTapped]
        
            }, completion: { (bool) in
                
                // self.mainView.backgroundColor = UIColor.red
                Game.sharedGameInstance.won = false
                self.audioPlayerRoundIsEndingSound.prepareToPlay()
                
                self.resetTimer()
                Game.sharedGameInstance.resetGame()
                Game.sharedGameInstance.updateTeamTurn()
                self.setTeamTurn()
                self.updateScore()
                self.removeWord()
                // self.animateTitleOnScreen()
        })
    }
    
    
    
    
    
    // Used by segueTimer to display the summaryViewController.
    func displayWordSummaryScreen() {
  
        // Red background color fade-in.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            // Fade-in redBackgroundColor.
            self.redBackgroundView.alpha = 0
        })
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
             
                // ANIMATION: Move the countdownView back into view for the next team.
                self.countdownView.center.x += self.view.bounds.width

                self.wordContainerView.alpha = 0
                }, completion:nil)
   
        Game.sharedGameInstance.segueFromDetailVC = false
        
        // Stop the gameTimer. 
        self.gameTimer.invalidate()
        
        
        // PERFORM THE SEGUE.
        performSegue(withIdentifier: "segueToSummaryScreen", sender: self)
    }
    
    
    
    // METHOD: animateTimesUpOffScreen()
    
    // (-) means up.
    func animateTimesUpOffScreen(){
        //print("In AnimateTimesUpOffScreen")
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.timesUpView.center.y -= self.view.bounds.height
            self.timesUpView.alpha = 0
            }, completion: {(bool) in
                UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    self.timesUpView.center.y += self.view.bounds.height
                    self.timesUpTimer.invalidate()
                }, completion: nil)
        })
    }
    
    
    
    
    
    
    // MARK: - Countdown animations ###############################################################################################
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
            self.countdownLabel.text = "\(self.countdown)"
        } else {
            self.countdownLabel.text = "Go!"
            self.countdownTimer.invalidate()
            self.view.isUserInteractionEnabled = true
            self.wordOnScreen = true
            self.roundInProgress = true
            self.countdown = 4
            
            // REMOVE: Go! offScreen.
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // OFFSCREEN:
                self.countdownView.center.x -= self.view.bounds.width
            })
            
            // START THE GAME.
            self.runGameTimer()
            self.animateNewWord()
        }
    }

    
    
    // MARK:- INIT METHODS - METHOD() ####################################################################################################
    
    func configureViewStyles(){
        let views = [self.startButton,
                     self.teamOneView,
                     self.teamTwoView,
                     self.teamOneScoreView,
                     self.teamTwoScoreView]
        for element in views {
            element?.layer.cornerRadius = 7
            element?.layer.borderColor = UIColor.white.cgColor
            element?.layer.borderWidth = 3
        }
    }
    

    ///
    func configureLabelContent() {
        self.teamOneLabel.text = "Team 1"
        self.teamTwoLabel.text = "Team 2"
    }
    
    
    ///
    func setColorForViewBackground() {
        /// Set the initial background color of the main view.
        self.view.backgroundColor = Game.sharedGameInstance.gameColor
    }
    
    
    

    // SET_TEAM_TURN()
    
    /// Updates the team name displayed for each turn.
    func setTeamTurn() {
        if Game.sharedGameInstance.teamOneIsActive {
            self.teamTurnLabel.text = "Team One"
        } else {
            self.teamTurnLabel.text = "Team Two"
        }
    }
    
    
    // UPDATE_SCORE()
    
    /// Changes the score labels content depending on the current score.
    func updateScore() {
        self.teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
    }
    
    

    /// Used by the gameTimer to generate gameplay.
    func startRound() {
        if Game.sharedGameInstance.won {
           
            // Invalidate the gameTimer.
            self.gameTimer.invalidate()
            
            // Stop the end round sound.
            self.audioPlayerRoundIsEndingSound.stop()
            
            // Segue to the CelebrationViewController.
            performSegue(withIdentifier: "segueToCelebration", sender: self)


        }
        
        self.countdownLabel.text = " "
        self.setTeamTurn()
        self.prepareGameTimer()
        self.startGameTimer()
        self.updateScore()
        self.endRound(40)
    }
    

    
    /**
     Used by the game to remove a word when the game round ends. It removes
     the word that is currently on the screen off to the right. Once the word
     is moved, the method lowers the view's alpha.
     */
    func removeWord() {
        if Game.sharedGameInstance.won {
            UIView.animate(withDuration: 0.4, animations: {
                // Move the word container offscreen right (+)
                self.wordContainerView.center.x += self.view.bounds.width
            },  completion: { (bool) in
                self.resetRound(0)
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.wordContainerView.center.x += self.view.bounds.width
            }, completion:nil)
        }
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
                   // print("Swiped right")
                    if Game.sharedGameInstance.teamOneIsActive {
                    
                        self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamOneScore += 1
                        teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
    
                        self.animateNewWordRightSwipe()
                    
                        // Play correct swipe sound. 
                        self.audioPlayerCorrectSwipe.play()
                    
                    } else {
                        
                        self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamTwoScore += 1
                        teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
                        
                        self.animateNewWordRightSwipe()
                        
                        // Play correct swipe sound.
                        self.audioPlayerCorrectSwipe.play()
                        
                    }
                }
            
            // Left swipe used to pass.
            case UISwipeGestureRecognizerDirection.left:
                if self.roundInProgress {
                    
                    if  self.wordOnScreen && self.timesSwipedRight < 2 {
                        self.audioPlayerSwipeSound.play()
                        self.timesSwipedRight += 1
                    
                      //  print("Swiped left")
                        self.animateNewWordLeftSwipe()
                        
                        // Play sound for wrong swipe.
                        self.audioPlayerWrondSwipe.play()
                  
                    } else {
                        
                        //    animatePassMessage()
                        self.audioPlayerWrondSwipe.play()
                    }
                }
            default:
                break
            }
        }
    }
    

    /**
     The initial word animation moves the wordContainerView into view from the left side of the screen.
     */
    func animateNewWordRightSwipe() {
        
        // Used to present words in summary screen.
        let currentWord = self.wordLabel.text
        Game.sharedGameInstance.correctWordsArray.append(currentWord!)
        
        // Animate new word from the right.
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
          
            // Increase word container alpha.
            self.wordContainerView.alpha = 1
            
            // Move the word view right (+)
            self.wordContainerView.center.x += self.view.bounds.width
            
            // Check to see if game has been won.
            Game.sharedGameInstance.checkForWinner()
            
        }, completion: {(Bool) in
            if  Game.sharedGameInstance.won {
                //self.animateGameWin()
              //  print("Game won!")
            } else {
                self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
            }
        })
        
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
            self.wordContainerView.center.x -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: nil)
    }
    
    
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
            self.wordContainerView.center.x -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: nil)
        
        
        UIView.animate(withDuration: 0.0, delay:0.4, options: [], animations: {
            // Moves the word that was just moved left off-screen all the way back to the right off-screen.
            self.wordContainerView.center.x += self.view.bounds.width + self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: { (Bool) in
                self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
        })
        
        // Animates the word back from the right off-screen, to the middle.
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
            self.wordContainerView.center.x -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: nil)
    }
    
    
    
    /**
     Sets a new word to display based on the selected category. Animates that word onto
     the screen from the left side of the view, and sets`wordOnScreen` equal to true.
     */
    func animateNewWord() {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // Get a new random word.
            self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
            self.wordContainerView.alpha = 1
            self.wordContainerView.center.x -= self.view.bounds.width
            }, completion: nil )
    }
    
    

    // MARK: - TIMER METHODS
    
    /**
     Used to runs the countdown that appears before a game round start.
     The method is called when the start button is touched.
     */
    func runCountdownTimer() {
        
        // Display countdownView.
        self.countdownView.alpha = 1
      
        // Disable interactions.
        self.view.isUserInteractionEnabled = false
        
        // Initiate countdown.
        if !self.countdownTimer.isValid {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameViewController.startCountdown), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
     Used to execute the game timer which notifies the players how much time
     is remaining. The method calls'startRound()`, which will execute
     all of the main game functions.
     */
    func runGameTimer() {
        if !self.gameTimer.isValid {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.startRound), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
     Used to change the text of the timer label from `01:00` to `00:59`.
     The method also updates the timeIsUp variable, which is used to 
     notify that a new game round has begun.
    */
    func prepareGameTimer() {
        timeIsUp = false
        if self.seconds == 0 {
            self.seconds = 60
            self.minutes = 0
            let strMinutes = String(format: "%1d", self.minutes)
            let strSeconds = String(format: "%02d", self.seconds)
            self.timerLabel.text = "\(strMinutes):\(strSeconds)"
        }
        self.countdown = 4
    }
    
    
    /// Used to decrease the time displayed on the game timer.
    func startGameTimer() {
        self.seconds -= 1
        self.minutes = 0
        let strMinutes = String(format: "%1d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timerLabel.text = "\(strMinutes):\(strSeconds)"
    }
    

    func resetTimer() {
        self.roundInProgress = false
        self.timeIsUp = true
        self.gameTimer.invalidate()
        self.seconds = 00
        self.minutes = 1
        let strMinutes = String(format: "%1d", self.minutes)
        let strSeconds = String(format: "%02d", self.seconds)
        self.timerLabel.text = "\(strMinutes):\(strSeconds)"
    }
}




