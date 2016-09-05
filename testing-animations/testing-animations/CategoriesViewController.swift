//
//  ViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    // Used to keep track of the current game.
    var game = Game()
    
    let category = Category()
    
    var categories = [Category]()
    
    private var lastContentOffset: CGFloat = 0
    
    
    // MARK: Button Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    

    // MARK - Button Actions
    @IBAction func categoryButtonTapped(sender: AnyObject) {}
    
    
    // MARK: - Audio
    var buttonSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ButtonTapped", ofType: "wav")!)
    var tapAudioPlayer = AVAudioPlayer()
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOfURL: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }
    

    // MARK: - Transition Managers
    let transitionManager = TransitionManager()
    let rulesScreenTransitionManager = RulesTransitionManager()

    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
        self.loadSoundFile()
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    */
    func loadCategories() {
        self.categories = [self.game.jesus, self.game.people, self.game.places, self.game.sunday, self.game.concordance, self.game.famous, self.game.worship, self.game.books, self.game.feasts, self.game.relics, self.game.revelation, self.game.relics, self.game.doctrine, self.game.sins, self.game.commands]
    }
    
    
    
    // MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.categoryButton.layer.cornerRadius = 7
        cell.categoryButton.backgroundColor = self.categories[indexPath.row].color
        cell.categoryButton.setTitle(self.categories[indexPath.row].title, forState: UIControlState.Normal)
        cell.tag = indexPath.row
        
        return cell
    }

    
    /**
        Used to animate rules menu fade-in.
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if scrollView.contentOffset.y > 30 {
            //self.rulesButton.setTitleColor(self.buttonBackgroundColor[1], forState: .Normal)
        }
        
        if scrollView.contentOffset.y > 30 {
            self.animateMenuFadeIn()
        } else if scrollView.contentOffset.y < 30 {
            self.animateMenuFadeOut()
        }
    }
    
    
    // MARK: - Segue Methods

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToRules" {
         
            // Button tapped sound.
            self.tapAudioPlayer.play()
            
            let rulesViewController = segue.destinationViewController as! RulesViewController
            rulesViewController.transitioningDelegate = self.rulesScreenTransitionManager
      

        } else if segue.identifier == "segueToDetails" {
                   
            // Fade rules if visible. 
            self.rulesButton.alpha = 0

            // Retrieve the indexPath row.
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! CollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)

            // Prepare destinationVC.
            let toViewController = segue.destinationViewController as! DetailViewController
            toViewController.game = self.game
            toViewController.categoryTapped = (indexPath!.row)
            toViewController.transitioningDelegate = self.transitionManager
        }
    }

    
    @IBAction func unwindToCategories(segue: UIStoryboardSegue){
        self.tapAudioPlayer.play()
    }
    
    
    // MARK: - Animations
    
    func animateMenuFadeIn() {
        UIView.animateWithDuration(0.5,animations: {
            self.rulesButton.alpha = 1
        }, completion: nil)
    }
    
    func animateMenuFadeOut() {
        UIView.animateWithDuration(0.5, animations: {
            self.rulesButton.alpha = 0
        }, completion: nil)
    }

}


