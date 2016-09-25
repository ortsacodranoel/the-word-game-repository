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

    //MARK:- Views
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
    
    //MARK:- Labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var teamTurnLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    // MARK:- Layout Constraints
    
    //MARK:- Buttons
    @IBOutlet weak var startButton: UIButton!
    
    //MARK:- Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    //MARK:- Timer Properties
    var gameTimer = Timer()
    var countdownTimer = Timer()
    var segueDelayTimer = Timer()
    
    var seconds = 00
    var minutes = 1
    var time = ""
    var timeIsUp = false
    
    //MARK:- Swipe Gesture Recognizer Properties
    var swipedRight = false
    var timesSwipedRight = 0

    //MARK:- Audio Properties
    
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
    
    
    
    // MARK:- VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.resetTimer()
        self.setTeamTurn()
        self.updateScore()
        self.setColorForViewBackground()
        self.configureViewStyles()
        self.configureLabelContent()
        
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
    }
    
    
    
    // MARK:- startButtonTouchUpInside()
    /// Animates menus off-screen and starts game.
    @IBAction func startButtonTouchUpInside(_ sender: AnyObject) {
        
        // TIME IS UP OFF SCREEN ANIMATE
        UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: Time'sUpView move top.
            self.timesUpView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: wordContainerView animate (invisible)
            self.wordContainerView.center.x += self.view.bounds.width
            }, completion: nil )
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
    }
    
    
    
    
    // MARK:- unwindToGame()
    /// Used to execute something when the view returns from the summary screen.
    @IBAction func unwindToGame(_ segue: UIStoryboardSegue){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            // Animate Start, Menu, and Team back onto the screen.
            self.startButtonView.center.y -= self.view.bounds.height
            self.menuButtonView.center.y += self.view.bounds.height
            self.teamTurnView.center.y += self.view.bounds.height

            }, completion: nil )
    }
    
    
    
    // ANIMATE_INITIAL_WORD()
    
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
        if self.seconds == 53 {
            // Play sounds alerting round coming to an end.
            // self.audioPlayerRoundIsEndingSound.prepareToPlay()
            // self.audioPlayerRoundIsEndingSound.play()
            UIView.animate(withDuration: 3.0, animations: { () -> Void in
                // Fade the background color to red to show that time is running out.
                self.view.backgroundColor = UIColor.red
            })
         // If time is up and nobody won the game.
        } else if self.seconds == time && Game.sharedGameInstance.won == false {

            Game.sharedGameInstance.updateTeamTurn()
            self.setTeamTurn()
            
            // Animate the 'Time's Up' back onto the screen.
            UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.timesUpView.alpha = 1
                self.timesUpView.center.y += self.view.bounds.height
                }, completion: nil)
        
            // Change the color of the screen back to original.
            UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                self.setColorForViewBackground()
                }, completion: nil)
                
            // Animate the Timer off screen prior to summary screen being presented.
            UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    self.timerView.center.y -= self.view.bounds.height
                }, completion: nil)

            // Reset to `1:00`.
            self.resetTimer()
            
            // Remove the current word displayed on the screen.
            self.removeWord()
            
            // Segue to the summary screen after 2.5 seconds.
            if !self.segueDelayTimer.isValid {
                self.segueDelayTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(GameViewController.displayWordSummaryScreen), userInfo:nil, repeats: false)
            }
        }
    }

    // DISPLAY_WORD_SUMMARY_SCREEN()
    // Present missed words.
    func displayWordSummaryScreen() {
            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
             
                // Move the countdownView back into view for the next team.
                self.countdownView.center.x += self.view.bounds.width
              
                // ANIMATION: Fade out `Time's Up` message off the screen so it's not seen during the game.
                self.timesUpView.alpha = 0
              
                self.wordContainerView.alpha = 0
                }, completion:nil)
   
        Game.sharedGameInstance.segueFromDetailVC = false
        
        // PERFORM THE SEGUE.
        performSegue(withIdentifier: "segueToSummaryScreen", sender: self)
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
    
    // CONFIGURE LABEL CONTENT - METHOD()
    
    func configureLabelContent() {
        self.teamOneLabel.text = "Team 1"
        self.teamTwoLabel.text = "Team 2"
    }
    
    // SET_COLOR_FOR_VIEW_BACKGROUND()
    
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
    
    
    // START_ROUND()
    
    /**
     Used by the `runGameTimer()` to execute main game methods during
     a game round.
     */
    func startRound() {
        self.countdownLabel.text = " "
        self.setTeamTurn()
        self.prepareGameTimer()
        self.startGameTimer()
        self.updateScore()
        self.endRound(50)
    }
    

    
    
    // REMOVE_WORD()
    
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
                // self.resetRound(0)
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.wordContainerView.center.x += self.view.bounds.width
            }, completion:nil)
        }
    }
    
    
    
    /// Unwinds the GameVC to the CategoryVC.
    @IBAction func categoriesMenuTouchUpInside(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
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
                    
                    if Game.sharedGameInstance.teamOneIsActive {
                    
                        //self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamOneScore += 1
                        teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
                      
                        //  self.animateNewWordRightSwipe()
                    } else {
                        self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamTwoScore += 1
                        teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
                        
                        //self.animateNewWordRightSwipe()
                    }
                }
            case UISwipeGestureRecognizerDirection.left:
                if self.roundInProgress {
                    if  self.wordOnScreen && self.timesSwipedRight < 2 {
                        self.audioPlayerSwipeSound.play()
                        self.timesSwipedRight += 1
         
                        //self.animateNewWordLeftSwipe()
                    
                    } else {
                    //    animatePassMessage()
                    }
                }
            default:
                break
            }
        }
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




