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
        UIColor(red: 91/255, green: 123/255, blue: 200/225, alpha: 1),  // Row 1
        UIColor(red: 196/255, green: 93/255, blue: 79/225, alpha: 1),   // Row 2
        UIColor(red: 196/255, green: 185/255, blue: 79/225, alpha: 1),  // Row 3
        UIColor(red: 212/255, green: 152/255, blue: 125/225, alpha: 1), // Row 4
        UIColor(red: 214/255, green: 133/255, blue: 157/225, alpha: 1), // Row 5
        UIColor(red: 150/255, green: 144/255, blue: 218/225, alpha: 1), // Row 6
        UIColor(red: 179/255, green: 193/255, blue: 230/225, alpha: 1), // Row 7
        UIColor(red: 228/255, green: 209/255, blue: 175/225, alpha: 1),
        UIColor(red: 221/255, green: 152/255, blue: 182/225, alpha: 1),
        UIColor(red: 133/255, green: 184/255, blue: 214/225, alpha: 1),
       
        UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),
        UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),
        UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),
        UIColor(red: 152/255, green: 221/255, blue: 217/225, alpha: 1),
        UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1),
        UIColor(red: 190/255, green: 68/255, blue: 93/225, alpha: 1),
        UIColor(red: 196/255, green: 54/255, blue: 93/225, alpha: 1)
    ]
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSoundFile()
        
       print(IAPManager.sharedInstance.products.count)
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


