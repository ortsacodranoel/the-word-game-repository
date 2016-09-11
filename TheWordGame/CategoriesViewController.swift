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

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{

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
    
    let colors = [
        UIColor(red: 147/255, green: 126/255, blue: 211/225, alpha: 1),             // Jesus
        UIColor(red: 62/255, green: 166/255, blue: 182/225, alpha: 1),              // People
        UIColor(red: 202/255, green: 115/255, blue: 99/225, alpha: 1),              // Places
        UIColor(red: 215/255, green: 184/255, blue: 136/225, alpha: 1),             // Sunday School
        UIColor(red: 55/255, green: 98/255, blue: 160/225, alpha: 1),               // Concordance
        UIColor(red: 163/255, green: 56/255, blue: 120/225, alpha: 1),              // Famous Christians
        UIColor(red: 199/255, green: 176/255, blue: 87/225, alpha: 1),              // Worship
        UIColor(red: 159/255, green: 200/255, blue: 223/225, alpha: 1),             // Books and Movies
        UIColor(red: 48/255, green: 142/255, blue: 145/225, alpha: 1),              // Feasts
        UIColor(red: 178/255, green: 215/255, blue: 255/225, alpha: 1),             // Relics and Saints
        UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),               // Revelation
        UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),             // Angels
        UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),             // Doctrine
        UIColor(red: 152/255, green: 221/255, blue: 217/225, alpha: 1),             // Sins
        UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1)               // Commands
    ]
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSoundFile()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.sharedGameInstance.categoriesArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.categoryButton.layer.cornerRadius = 7
        cell.categoryButton.backgroundColor = self.colors[indexPath.row]
        cell.tag = indexPath.row
        cell.categoryButton.setTitle(Game.sharedGameInstance.categoriesArray[indexPath.row].title, forState: UIControlState.Normal)
        
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


