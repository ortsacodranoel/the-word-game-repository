 //
//  SummaryViewController.swift
//  TheWordGame
//
//  Created by Leo on 9/19/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit
import CoreData

class SummaryViewController: UIViewController {

    // MARK: - General properties
    var categoryTapped = Int()
    
    // MARK: - Views
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    // MARK: - Label
    @IBOutlet weak var wordSummaryLabel: UILabel!
    
    @IBOutlet weak var wordSummaryTextview: UITextView!
    
    

    
    
    
    // MARK: - Sound effect paths.
    
    // Used to create tap sound effect when button touched.
    let soundEffectButtonTap = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    // Used for menu interactions sounds.
    var audioPlayerButtonTapSound = AVAudioPlayer()
    
    
    
    
    // MARK: - BUTTON ACTIONS
    
    

    @IBAction func backBtnTapped(_ sender: AnyObject) {
        
        print("Back button tapped")
        self.audioPlayerButtonTapSound.play()
    }
    
    
    
    
    // MARK: - AUDIO SETUP
    
    
    
    
    /// Configures the AVAudioPlayers with their respective sound files and prepares them to be played.
    func loadSounds() {
        do {
            
            // Configure Audioplayers.
            self.audioPlayerButtonTapSound = try AVAudioPlayer(contentsOf: self.soundEffectButtonTap, fileTypeHint: "wav")
            
            // Prepare to play.
            self.audioPlayerButtonTapSound.prepareToPlay()

        } catch {
            print("Error: unable to find sound files.")
        }
    }
    
    
    
    
    
    // MARK: - VIEW SETUP
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

        
        let fetchRequest : NSFetchRequest<TutorialPopUp>
        // 1. Create the fetch request for all entities of type TutorialPopUp.
        
        if #available(iOS 10.0, OSX 10.12, *) {
            fetchRequest = TutorialPopUp.fetchRequest()
            // Fetch request for newer iOS versions.
            
        } else {
            fetchRequest = NSFetchRequest(entityName: "TutorialPopUp")
            // Fetch request for older iOS versions.
        }
        
        
        // Retrieve saved entity.
        do {
            
            let result = try managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if (result.count > 0) {
                
                let entity = result[0] as! NSManagedObject
                // Get the first entity.
                
                entity.setValue(true, forKey: "enabled")
                
                try managedObjectContext.save()

            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
        // Used to append correct/missed words.
        let words = NSMutableAttributedString()
        // Used to add the carriage return to the attributed string passed to the wordSummaryTextview.
        let cr = NSMutableAttributedString(string: "\n")
        
        
        // Retrieve the missed words.
        for missedWord in Game.sharedGameInstance.missedWordsArray {
          
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 30)]

            let myString = NSMutableAttributedString(string: missedWord, attributes:attrs)
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.length))
            
            // Add the new word to the string.
            words.append(myString)
            // Append carriage return.
            words.append(cr)
            // Add word to text view.
            self.wordSummaryTextview.attributedText = words
            
        }
        // Retrieve correct words.
        for correctWord in Game.sharedGameInstance.correctWordsArray {
            
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 30)]
            
            let myString = NSMutableAttributedString(string: correctWord, attributes:attrs)
            myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:0,length:myString.length))
          
            // Add the new word to the string.
            words.append(myString)
            // Append carriage return.
            words.append(cr)
            self.wordSummaryTextview.attributedText = words
        }
        

        self.wordSummaryTextview.textAlignment = .center
        
        
        
        
        // Load sounds.
        self.loadSounds()
    }
    
    
    /*
     Used to layout the wordSummaryTextview when the screen noted.
    */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.wordSummaryTextview.setContentOffset(CGPoint.zero, animated: false)
        
        
    }
    
    
    
    /*
     
     */    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the color of the category.
        let categoryColor = Game.sharedGameInstance.gameColor.cgColor
        // Setup view styles.
        self.mainView.layer.cornerRadius = 7
        self.mainView.layer.borderColor = categoryColor
        self.mainView.layer.borderWidth = 3
        self.backgroundView.layer.cornerRadius = 7
        self.wordSummaryLabel.textColor = Game.sharedGameInstance.gameColor

        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Words Summary", attributes: underlineAttribute)
        self.wordSummaryLabel.attributedText = underlineAttributedString
        


    }
    
    
    /*
     
     */
    /// Set the initial background color of the main view.
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.colors[categoryTapped]
    }
}
