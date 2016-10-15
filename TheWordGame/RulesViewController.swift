//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class RulesViewController: UIViewController {
    
    // MARK: - Game Properties
    @IBOutlet weak var rulesScrollView: UIScrollView!
    
    // MARK: - Labels
    @IBOutlet weak var rulesTitle: UILabel!
    @IBOutlet weak var ruleOne: UILabel!
    @IBOutlet weak var ruleTwo: UILabel!
    @IBOutlet weak var ruleThree: UILabel!
    @IBOutlet weak var ruleFour: UILabel!
    @IBOutlet weak var ruleFive: UILabel!
    @IBOutlet weak var ruleSix: UILabel!
    
    @IBOutlet weak var rulesLabel: UILabel!

    @IBOutlet weak var settingsLabel: UILabel!

    // Visual Effects
    var blurView:UIVisualEffectView!
    
    @IBAction func rulesButtonTapped(_ sender: AnyObject) {
    
        if let url = URL(string: "http://www.thewordgameapp.com/official-rules-of-the-game/") {
            UIApplication.shared.openURL(url)
        }
    
    }
    
    @IBAction func restorButtonTapped(_ sender: AnyObject) {
        
        
    }
    
    
    // MARK:- Button Actions
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        self.loadSoundFile()
        self.tapAudioPlayer.play()
        self.performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    

    
    // MARK: - Transition Managers
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Swipe Gesture Recognizer Properties
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    
    // MARK: - Audio
    var buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    
    var tapAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var backgroundView: UIView!

    
    
    
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOf: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }
    
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Underline Settings.
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Settings", attributes: underlineAttribute)
        self.settingsLabel.attributedText = underlineAttributedString

        // Background blur.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.blurView.frame = self.view.bounds
        self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.addSubview((self.blurView))
        
    }
    
    
    // MARK: - Swipe Gestures
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right: // RIGHT SWIPE
                performSegue(withIdentifier: "unwindToCategories", sender: self)
            default:
                break
            }
        }
    }
    
    
}

