//
//  ViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{

    // Used to keep track of the current game.
    var game = Game()
    
    private var lastContentOffset: CGFloat = 0
    
    // MARK: Button Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var rulesButton: UIButton!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
   let categories = [UIImage(named:"Jesus"),UIImage(named:"People"),UIImage(named:"Places"),UIImage(named:"FamousChristians"),UIImage(named:"Worship"),UIImage(named:"Booksandmovies"),UIImage(named:"Concordance"),UIImage(named:"Feasts"),UIImage(named:"Angels"), UIImage(named:"SundaySchool"),UIImage(named:"Revelation"), UIImage(named:"Doctrine"), UIImage(named:"Sins"), UIImage(named:"Commands")]
    
    let titles = ["Jesus","People","Places","Famous Christians","Worship","Books and Movies","Concordance","Feasts","Angels","Sunday School","Revelation","Doctrine","Sins","Commands"]
    
    // Button actions.
    @IBAction func categoryButtonTapped(sender: AnyObject) {}
    
    // MARK: - Transition Managers
    let transitionManager = TransitionManager()
    let rulesScreenTransitionManager = RulesTransitionManager()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.categoryButton.setBackgroundImage(self.categories[indexPath.row], forState: UIControlState.Normal)
        
        cell.categoryButton.setTitle(self.titles[indexPath.row], forState: UIControlState.Normal)

        cell.tag = indexPath.row
        
        return cell
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            self.animateMenuFadeIn()
        } else if scrollView.contentOffset.y > 30{
            self.animateMenuFadeOut()
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToRules" {
            
            let rulesViewController = segue.destinationViewController as! RulesViewController
            rulesViewController.transitioningDelegate = self.rulesScreenTransitionManager
        } else {
        
            
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

    
    @IBAction func unwindToCategories(segue: UIStoryboardSegue){}

    
    
    // MARK: - Animations
    func animateMenuFadeIn() {
        
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.rulesButton.alpha = 1
            }, completion: nil)
    }
    
    func animateMenuFadeOut() {
        
        UIView.animateWithDuration(0.5, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            
            self.rulesButton.alpha = 0
            }, completion: nil)
    }

}


