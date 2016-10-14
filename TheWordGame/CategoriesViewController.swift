//
//  ViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit
import CoreData

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    fileprivate var lastContentOffset: CGFloat = 0
    
    // MARK: - View Properties
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Audio Timer
    /// Used to delay the tutorialView animation.
    var popSoundTimer = Timer()

    // MARK: Button Properties
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var rulesButton: UIButton!
    
    // MARK: - Transition Managers
    let transitionManager = TransitionManager()
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Audio
    
    var popSound = URL(fileURLWithPath: Bundle.main.path(forResource: "BubblePop", ofType: "mp3")!)
    var popAudioPlayer = AVAudioPlayer()
    
    var buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    var tapAudioPlayer = AVAudioPlayer()
    
    // Retreive the managedObjectContext from AppDelegate
    @IBAction func settingsBtnTapped(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "segueToSettings", sender: self)
        
        
        
    }
    
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    

    
    
    
    
    
    
    
    
    
    
    
    // MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add gesture recognizer for tap on overlayView.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(CategoriesViewController.hideTutorialAction(sender:)))
        self.viewOverlay.addGestureRecognizer(tapGestureRecognizer)
        
        // Load sounds.
        self.loadSoundFile()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        if isTutorialEnabled() {
            
            // Timer to play pop sound.
            if !self.popSoundTimer.isValid {
                self.popSoundTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(CategoriesViewController.playPopSound), userInfo:nil, repeats: false)
            }

            UIView.animate(withDuration: 0.7, delay: 0.5,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.viewOverlay.alpha = 0.8
                // Change the color of the screen so tutorial pop up stands out.
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.7,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.tutorialView.alpha = 1
                self.tutorialView.center.x += self.view.bounds.width
                // Move the tutorial view right.
                self.tutorialView.center.y -= self.view.bounds.height
                // Move the tutorial view up.
            }, completion: nil )
            
            self.disablePopUps()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - Tutorial methods
    /// Used to check if tutorial is enabled.
    func isTutorialEnabled() -> Bool {
        let sharedTutorialInstance = (UIApplication.shared.delegate as! AppDelegate).sharedTutorialEntity
        // Get the tutorial instance.
        let enabled = sharedTutorialInstance?.value(forKey: "categoriesScreenEnabled") as! Bool
        // Retrieve data.
        return enabled
    }
    
    
    /// Disable pop ups.
    func disablePopUps() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(false, forKey: "categoriesScreenEnabled")
        
        do {
            print("Saving Context")
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

    
    
    
    
    // MARK: - Audio Methods.
    func loadSoundFile() {
        do {
            
            self.tapAudioPlayer = try AVAudioPlayer(contentsOf: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
            
            self.popAudioPlayer = try AVAudioPlayer(contentsOf: self.popSound, fileTypeHint: "mp3")
            self.popAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }

    func playPopSound() {
        // Play pop sound once the tutorial view animates.
        self.popAudioPlayer.play()
    }
    
    
    
    
    /**
     Used to hide the tutorial bubble from view and fade out the overlay when
     the overlayView or bubbleView is tapped.
    */
    func hideTutorialAction(sender:UITapGestureRecognizer) {
        
        // Animate overlay off-screen.
        UIView.animate(withDuration: 0.7, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            
            // Increase the alpha of the view.
            self.viewOverlay.alpha = 0

            }, completion: nil)
        
        // Animate tutorialView off-screen.
        UIView.animate(withDuration: 0.5, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            
            self.tutorialView.alpha = 1
            
            // Move the view into place.
            self.tutorialView.center.x -= self.view.bounds.width
            self.tutorialView.center.y += self.view.bounds.height
            }, completion: { (bool) in
                self.tutorialView.alpha = 0
        })
    }


    
    
    
    
    // MARK: - Button Actions
    
    /// Used to play sound when the button is tapped.
    @IBAction func unwindToCategories(_ segue: UIStoryboardSegue){
        self.tapAudioPlayer.play()
    }
    

    /// Needed for segue action.
    @IBAction func categoryButtonTapped(_ sender: AnyObject) {}
    
    
    
    
    
    
    
    
    
    // MARK: - Collection View Methods
    
    ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.sharedGameInstance.categoriesArray.count
    }
    
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.categoryButton.layer.cornerRadius = 7
        cell.categoryButton.backgroundColor = Game.sharedGameInstance.colors[(indexPath as NSIndexPath).row]
        cell.tag = (indexPath as NSIndexPath).row
        cell.categoryButton.setTitle(Game.sharedGameInstance.categoriesArray[(indexPath as NSIndexPath).row].title, for: UIControlState())
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "segueToRules" {
            self.tapAudioPlayer.play()
            let rulesViewController = segue.destination as! RulesViewController
            rulesViewController.transitioningDelegate = self.rulesScreenTransitionManager
       
        } else if segue.identifier == "segueToDetails" {
            // Fade rules if visible.
            self.rulesButton.alpha = 0
            
            // Retrieve the indexPath row.
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! CollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
          
            Game.sharedGameInstance.gameColor = Game.sharedGameInstance.colors[((indexPath! as NSIndexPath).row)]
            
            // Prepare destinationVC.
            let toViewController = segue.destination as! DetailViewController
            toViewController.categoryTapped = ((indexPath! as NSIndexPath).row)
            toViewController.transitioningDelegate = self.transitionManager
        }
    }
    


}



















/**


 
 /// Animates the first tutorial step on screen load.
 func animateTutorialStep() {
 
 tutorialTimer.invalidate()
 
 print("in animate tutorial step")
 
 
 }
 
 
 
 

    // MARK: - Animations
    func animateMenuFadeIn() {
        UIView.animate(withDuration: 0.5,animations: {
            self.tutorialView.alpha = 1
            }, completion: nil)
    }



    func animateMenuFadeOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rulesButton.alpha = 0
            }, completion: nil)
    }





    /// Used to animate rules menu fade-in.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 30 {
            //self.rulesButton.setTitleColor(self.buttonBackgroundColor[1], forState: .Normal)
        }

        if scrollView.contentOffset.y > 30 {
            self.animateMenuFadeIn()
        } else if scrollView.contentOffset.y < 30 {
            self.animateMenuFadeOut()
        }
    }

*/
