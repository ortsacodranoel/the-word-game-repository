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


    
    // MARK:- Button Actions
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        self.loadSoundFile()
        self.tapAudioPlayer.play()
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    /**
        Used to link to the official rules page.
    */
    @IBAction func rulesButtonTapped(_ sender: AnyObject) {
        if let url = URL(string: "http://www.thewordgameapp.com/official-rules-of-the-game/") {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - Transition Managers
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Swipe Gesture Recognizer Properties
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    
    // MARK: - Audio
    var buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    
    var tapAudioPlayer = AVAudioPlayer()
    
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
    
    /**
     
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        
        
        
        
//        // Swipe Right - Gesture Recognizer.
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        self.view.addGestureRecognizer(swipeRight)
//        
        UIView.animate(withDuration: 0.4, delay: 1.0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
           // self.rulesLabel.alpha = 1
        
            }, completion: nil)
    }
    

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

