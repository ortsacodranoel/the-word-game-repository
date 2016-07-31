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

    @IBOutlet weak var collectionView: UICollectionView!
    
    
   let categories = [UIImage(named:"jesusCategory"),UIImage(named:"peopleCategory"),UIImage(named:"placesCategory"),UIImage(named:"famousCategory"),UIImage(named:"worshipCategory"),UIImage(named:"booksCategory"),UIImage(named:"concordanceCategory"),UIImage(named:"feastsCategory"),UIImage(named:"angelsCategory"), UIImage(named:"sundayCategory"),UIImage(named:"revelationCategory"), UIImage(named:"doctrineCategory"), UIImage(named:"sinsCategory"), UIImage(named:"commandsCategory")]
    
    
    let categoriesSelected = [UIImage(named:"jesusCategorySelected"),UIImage(named:"peopleCategorySelected"),UIImage(named:"placesCategorySelected"),UIImage(named:"famousCategorySelected"),UIImage(named:"worshipCategorySelected"),UIImage(named:"booksCategorySelected"),UIImage(named:"concordanceCategorySelected"),UIImage(named:"feastsCategorySelected"),UIImage(named:"angelsCategorySelected"), UIImage(named:"sundayCategorySelected"),UIImage(named:"revelationCategorySelected"), UIImage(named:"doctrineCategorySelected"), UIImage(named:"sinsCategorySelected"), UIImage(named:"commandsCategorySelected")]
    
    // MARK: Button Actions.
    @IBAction func categoryButtonTapped(sender: AnyObject) {}
    
    let transitionManager = TransitionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start a new game.
        let newGame = Game()
        
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
        cell.categoryButton.setBackgroundImage(self.categoriesSelected[indexPath.row], forState: UIControlState.Highlighted)
        cell.tag = indexPath.row
        
        return cell
    }

    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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

    
    @IBAction func unwindToCategories(segue: UIStoryboardSegue){}
    
}


