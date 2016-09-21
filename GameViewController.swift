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
    ///
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
    @IBOutlet weak var startButtonViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var wordContainerViewCenterX: NSLayoutConstraint!
    
    
    
    
    //MARK:- Buttons
    @IBOutlet weak var startButton: UIButton!
    
    //MARK:- Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    //MARK:- Timer Properties
    var gameTimer = Timer()
    var countdownTimer = Timer()
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
        
        // CountdownView must not be seen on load.
        self.countdownView.alpha = 0
        
        self.resetTimer()
        self.setTeamTurn()
        self.updateScore()
        self.setColorForViewBackground()
        self.configureViewStyles()
        self.configureLabelContent()
      
        // Check if the segue is coming from the DetailVC.
        if Game.sharedGameInstance.segueFromDetailVC == true {
            self.initialMenuItemsPresentation()
        }
        
        // Move container offscreen right.
        self.wordContainerViewCenterX.constant += view.bounds.width
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
    
    
    //MARK:- BUTTONS METHODS
    
    /// Animates menus off-screen and starts game.
    @IBAction func startButtonTouchUpInside(_ sender: AnyObject) {
        
        // REMOVE MENUS + TURN
        // Animate menu offscreen.
        self.offScreenAnimate(viewObject:self.menuButtonView, withDirection: UP, delay: 0)
        // Animate StartButtonView off screen.
        self.offScreenAnimate(viewObject: self.startButtonView, withDirection: DOWN, delay: 0)
        // Animate teamTurnView offScreen
        self.offScreenAnimate(viewObject: self.teamTurnView, withDirection: UP, delay: 0.2)
        
        // Run countdowntimer
        self.runCountdownTimer()
    }
    
    
    /// Used to unwind from summary screen.
    @IBAction func unwindToGame(_ segue: UIStoryboardSegue){
        self.animateNewTeamTurn()
    }
    
    
    /// Unwinds the GameVC to the CategoryVC.
    @IBAction func categoriesMenuTouchUpInside(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    
    
    // MARK:- INIT METHODS ---
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
    
    func configureLabelContent() {
        self.teamOneLabel.text = "Team 1"
        self.teamTwoLabel.text = "Team 2"
    }
    

    /// Set the initial background color of the main view.
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.gameColor
    }
    
    

    

    // MARK: - TIMER METHODS ---
    
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
    
    
    
    // MARK: - Game methods

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
    
    
    /**
     Sets a new word to display based on the selected category. Animates that word onto
     the screen from the left side of the view, and sets`wordOnScreen` equal to true.
     */
    func animateInitialWord() {
        
        /// Make sure other animations are not visible
        self.startButtonView.alpha = 0
        self.menuButtonView.alpha = 0
        self.teamTurnView.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay:3.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
         

            
            
            self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
            self.wordContainerView.alpha = 1
            self.wordContainerViewCenterX.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            
        }, completion: nil )
    }
    
    
    
    /**
     Used to run all methods that prepare the next round of the game.
     When the time reaches 3 seconds left, the method runs the alert
     sound.
     
     Parameters time: Int - used to indicate at what time the timer should stop.
     */
    func endRound(_ time: Int) {
        if self.seconds == 53 {
            // self.audioPlayerRoundIsEndingSound.prepareToPlay()
            // self.audioPlayerRoundIsEndingSound.play()
            // self.animateBackgroundColorFadeIn()
        } else if self.seconds == time && Game.sharedGameInstance.won == false { // If time is up  and nobody won the game.
            Game.sharedGameInstance.updateTeamTurn()
            self.setTeamTurn()
           // self.animateTimeIsUpMessageOnScreen()
            self.resetTimer()

            // Display word summary.
            self.displayWordSummary()
            
            // self.removeWord()
        }
    }
    
    
    /// Updates the team name displayed for each turn.
    func setTeamTurn() {
        if Game.sharedGameInstance.teamOneIsActive {
            self.teamTurnLabel.text = "Team One"
        } else {
            self.teamTurnLabel.text = "Team Two"
        }
    }
    
    
    /// Changes the score labels content depending on the current score.
    func updateScore() {
        self.teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
    }
    
    
   

    
    // MARK: - Countdown animations
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
            
            // Move "Go!" offscreen.
            self.animate(viewObject: self.countdownView, duration: 0.2, delay: 0.5, withDirection: "Right", originalPosition: self.countdownView.center.x)
            
            // START THE GAME.
            self.runGameTimer()
            self.animateInitialWord()
        }
    }
    
    

    
    // MARK: - Menu animations
    
    /// Animates teamOneView,teamTwoView,teamOneScoreView,teamTwoScoreView,menuView, and timerView onto the screen.
    func initialMenuItemsPresentation() {
        // Bottom-up animations.
        UIView.animate(withDuration: 0.4, delay: 0.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.startButtonView.alpha = 1
            self.startButtonView.center.y -= self.view.bounds.height
            self.teamOneView.alpha = 1
            self.teamOneView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScoreView.alpha = 1
            self.teamOneScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoView.alpha = 1
            self.teamTwoView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScoreView.alpha = 1
            self.teamTwoScoreView.center.y -= self.view.bounds.height
            }, completion: nil)
        // Top-down animations.
        UIView.animate(withDuration: 0.4, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.menuButtonView.alpha = 1
            self.menuButtonView.center.y += self.view.bounds.height
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.timerView.alpha = 1
            self.timerView.center.y += self.view.bounds.height
            }, completion: nil)
    }


    
    
    /// Animate view off screen.
    func offScreenAnimate(viewObject: UIView, withDirection: String, delay: TimeInterval) {
        switch withDirection {
            case "UP":
                UIView.animate(withDuration:0.5, delay:delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    viewObject.center.y -= self.view.bounds.height
                    }, completion: nil)
            case "DOWN":
                UIView.animate(withDuration:0.5, delay:delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    viewObject.center.y += self.view.bounds.height
                    }, completion: nil)
        default:
            break
        }
    }


    
    
    
    // Present missed words.
    func displayWordSummary() {
        // Fade the View color to white so that we can see the words in red and green.
        UIView.animate(withDuration: 0.2, animations: {
            //self.view.backgroundColor = UIColor.white
        })
        
        Game.sharedGameInstance.segueFromDetailVC = false
        performSegue(withIdentifier: "segueToSummaryScreen", sender: self)
    }
    
    
    // Used to bring animations back onto the screen for a new team's turn.
    func animateNewTeamTurn() {
    UIView.animate(withDuration: 0.4, delay: 1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
        
            self.startButtonView.alpha = 1
            self.startButtonView.center.y -= self.view.bounds.height
            
            self.menuButtonView.alpha = 1
            self.menuButtonView.center.y += self.view.bounds.height
            
            self.teamTurnView.alpha = 1
            self.teamTurnView.center.y += self.view.bounds.height
        
        
        }, completion: nil)
    }
    
    
    
    
    // Used after move animation to bring the view back to original position.
    func resetViewPosition(viewObject: UIView, position: CGFloat) {
        self.fade(viewObject: viewObject, duration: 0, delay: 0, inOrOut: OUT)
        viewObject.center.y = position
        self.fade(viewObject: viewObject, duration: 1, delay: 1, inOrOut: IN)
    }
    
    
    
    
    /// Fades views.
    func fade(viewObject: UIView, duration:TimeInterval, delay:TimeInterval, inOrOut: String ) {
        switch inOrOut {
            case "OUT":
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    viewObject.alpha = 0
                    }, completion: nil)
            case "IN":
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    viewObject.alpha = 1
                    }, completion: nil)
        default:
            break
        }
    }

    
    
    /*
        Used to animate a view on or off screen to the left or right and then return 
        to its original position with an alpha of 0
    */
    func animate(viewObject: UIView, duration: TimeInterval, delay: TimeInterval, withDirection: String, originalPosition: CGFloat){
    
        switch withDirection {
            case "Right":
                
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                        viewObject.center.x += self.view.bounds.width
                    }, completion: {(bool) in
                
                        // Decrease alpha.
                        viewObject.alpha = 0
                        viewObject.center.x = originalPosition
                })
            
            case "Left":
    
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                        viewObject.center.x += self.view.bounds.width
                }, completion: nil)
            
        default:
            break
        }
    }
}




