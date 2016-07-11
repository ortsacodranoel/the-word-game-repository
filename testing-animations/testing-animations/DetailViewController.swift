//
//  DetalViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/27/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Variables.
    var categoryTapped = Int()
    var backgroundColor = UIColor()
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Buttons.
    @IBOutlet weak var selectButton: UIButton!
    

    
    // MARK: - Views.
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!
   
    
    
    // MARK: - Actions.

    @IBOutlet var mainView: UIView!
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCategories", sender: self)
        // exitAnimations()
    }

    
    
    // MARK: - Data.
    let titles = ["Jesus","People","Places", "Famous", "Worship", "Books", "Concordance", "Feasts", "Angels", "Sunday School", "Revelation", "Doctrine", "Sins", "Commands"]
    let colors = [UIColor(red: 147/255, green: 126/255, blue: 211/225, alpha: 1),   // Jesus
                    UIColor(red: 62/255, green: 166/255, blue: 182/225, alpha: 1),  // People
                    UIColor(red: 202/255, green: 115/255, blue: 99/225, alpha: 1),  // Places
                    UIColor(red: 215/255, green: 184/255, blue: 136/225, alpha: 1),  // Famous
                    UIColor(red: 55/255, green: 98/255, blue: 160/225, alpha: 1),    // Worship
                    UIColor(red: 163/255, green: 56/255, blue: 120/225, alpha: 1),  // Books
                    UIColor(red: 199/255, green: 176/255, blue: 87/225, alpha: 1),  // Concordance
                    UIColor(red: 159/255, green: 200/255, blue: 223/225, alpha: 1),  // Feasts
                    UIColor(red: 48/255, green: 142/255, blue: 145/225, alpha: 1),  // Angels
                    UIColor(red: 178/255, green: 215/255, blue: 255/225, alpha: 1),  // Sunday
                    UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),  // Revelation
                    UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),  // Doctrine
                    UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),  // Sins
                    UIColor(red: 150/255, green: 165/255, blue: 141/225, alpha: 1),  // Commands
                    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Gesture Recognizer to enable swiping back to Categories Menu.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.handleSwipes(_:)))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        self.selectButton.setBackgroundImage(UIImage(named:"select_tapped"), forState: .Highlighted)
        self.TitleView.center.x = 720
        self.descriptionView.center.x = 720
        self.selectButton.center.y = 720
        

        
        setCategory(categoryTapped)
        setColor(categoryTapped)
        
        self.startAnimations()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Custom Methods.
    
    
    
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .Right) {
            performSegueWithIdentifier("unwindToCategories", sender: self)

        }
    }
    
    
    
    func setCategory(category: Int) {
        titleLabel.text = titles[category]
    }
    
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as? GameViewController
        destinationVC?.categoryTapped = self.categoryTapped

    }
    
    
    func startAnimations() {
        
        UIView.animateWithDuration(0.2, delay: 0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.TitleView.center.x = 0
        }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    self.descriptionView.center.x = 0
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.6,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.selectButton.center.y = 0
                                    
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.8,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.backButtonView.alpha = 1.0
                                    
            }, completion: nil)
    }
    
    
    func exitAnimations() {
        
        if self.backButtonView.alpha == 1.0 {
        
        UIView.animateWithDuration(0.2, delay: 0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.TitleView.center.x = 720
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    self.descriptionView.center.x = 720
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.6,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.selectButton.center.y = 720
                                    
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.8,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.backButtonView.alpha = 0
                                    
            }, completion: nil)
    
        } else {
            return     }
    }
    
    
} // END
