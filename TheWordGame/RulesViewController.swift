//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class RulesViewController: UIViewController, IAPManagerDelegate {
    
    // MARK: - Game Properties
    @IBOutlet weak var rulesScrollView: UIScrollView!
    
    // MARK: - Labels
    @IBOutlet weak var settingsLabel: UILabel!

    // MARK: - Visual Effects
    var blurView:UIVisualEffectView!
    
    // MARK: - CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    
    

    
    // MARK: - Transition Managers
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Swipe Gesture Recognizer Properties
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    
    // MARK: - Audio Properties
    var buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    
    var tapAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var backgroundView: UIView!

    
    

    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.sharedInstance.delegate = self
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
    
    
    
    // MARK: - Button Methods
    
    @IBAction func rulesButtonTapped(_ sender: AnyObject) {
        if let url = URL(string: "http://www.thewordgameapp.com/official-rules-of-the-game/") {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func restorButtonTapped(_ sender: AnyObject) {
        IAPManager.sharedInstance.restorePurchases()
    }
    
    
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        self.loadSoundFile()
        self.tapAudioPlayer.play()
        self.performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    @IBAction func enableTutorialTapped(_ sender: AnyObject) {
        self.enablePopUps()
        self.performSegue(withIdentifier: "unwindToCategories", sender: self)

    }
    
    
    // MARK: - Tutorial Methods 
    
    /// Enable pop ups.
    func enablePopUps() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(true, forKey: "gameScreenEnabled")
        delegate.sharedTutorialEntity.setValue(true, forKey: "categoriesScreenEnabled")
        do {
            print("Enabled Tutorial & Saving Context")
            try context.save()
            Game.sharedGameInstance.showPopUp = true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    
    
    
    
    // MARK: - Audio Methods
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOf: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }
    
    
    // MARK: - In-App Purchase Methods
    
    func managerDidRestorePurchases() {
        let alertController = UIAlertController(title: "In-App Purchase", message: "Your purchases have been restored", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style:.default,handler: {action in self.performSegue(withIdentifier: "unwindToCategories", sender: self)})
        alertController.addAction(okAction)
        self.present(alertController,animated:true, completion:nil)
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

