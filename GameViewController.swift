import UIKit
import AVFoundation

class GameViewController: UIViewController {

    var categoryTapped = Int()
    
    // MARK: - Views
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var teamOneView: UIView!
    @IBOutlet weak var teamOneScoreView: UIView!
    @IBOutlet weak var teamTwoView: UIView!
    @IBOutlet weak var teamTwoScoreView: UIView!
    
    @IBOutlet weak var startButtonView: UIView!
    
    // MARK: - Buttons
    @IBOutlet weak var startButton: UIButton!
    
    
    
    
    // MARK: - Audio
    
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
    
    
    
    
    // MARK: - Button Actions
    @IBAction func categoriesMenuTouchUpInside(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    // MARK:- Init() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setColorForViewBackground()
        self.presentMenuItems()
        
        // Start button configuration.
        self.startButton.layer.cornerRadius = 7
        self.startButton.layer.borderColor = UIColor.white.cgColor
        self.startButton.layer.borderWidth = 3
        
        self.startButtonView.center.y += self.view.bounds.height


    }
    
    /// Set the initial background color of the main view. 
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.colors[categoryTapped]
    }

    
    
    
    // MARK: - Animations
    
    /// Animates teamOneView,teamTwoView,teamOneScoreView,teamTwoScoreView,menuView, and timerView onto the screen.
    func presentMenuItems() {
       
        // Bottom-up animations.
        UIView.animate(withDuration: 0.4, delay: 0.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneView.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamOneScoreView.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoView.center.y -= self.view.bounds.height
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.teamTwoScoreView.center.y -= self.view.bounds.height
        }, completion: nil)
        
        // Top-down animations.
        UIView.animate(withDuration: 0.4, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.menuButtonView.center.y += self.view.bounds.height
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
            self.timerView.center.y += self.view.bounds.height
         
            self.startButtonView.center.y -= self.view.bounds.height
            
            
            //self.teamView.alpha = 1
            //self.teamView.center.y += self.view.bounds.height
            
            //self.startButton.alpha = 1
            //self.startButton.center.y += self.view.bounds.height
            //self.centerAlignStartButton.constant
            
            }, completion: nil)
    }




}




