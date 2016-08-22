//
//  DetalViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/27/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // Used to keep track of the current game.
    var game = Game()
    
    
    // MARK: - Variables.
    var categoryTapped = Int()
    var backgroundColor = UIColor()
    
    
    // MARK: - Buttons.
    @IBOutlet weak var selectButton: UIButton!

    
    // MARK: - Views.
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!

    
    // MARK: - Labels.
    @IBOutlet weak var descriptionViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Actions.
    @IBAction func backButtonTapped(sender: AnyObject)  {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }

    
    // MARK: - Data.
    let titles = ["Jesus","People","Places","Sunday School","Concordance","Famous Christians","Worship","Books and Movies","Feasts","Relics and Saints","Revelation","Angels","Doctrine","Sins","Commands"]
    
    
    let colors  = [
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
        UIColor(red: 150/255, green: 165/255, blue: 141/225, alpha: 1),             // Sins
        UIColor(red: 150/255, green: 165/255, blue: 141/225, alpha: 1)              // Commands
    ]
    
    let descriptions = ["His many names, adjectives to describe His character, and words associated with our Lord Jesus Christ. ",
                      "Men and women of the Bible, from Genesis to Revelation and from the meek to the mighty.",
                      "Countries, cities, lands, bodies of water, geological landmarks, and man-made structures of the Bible and bible times. ",
                      "Stories from the Bible as well as Jesus’ parables.  * teams need not guess the exact answer, but must clearly guess the correct story or parable.",
                      "Words found in the concordance of a Bible, excluding names and places.",
                      "Historical and influential Christians, TV evangelists, and Celebrities who have claimed Faith in Christ.",
                      "Hymns, words and songs of worship, Christian bands/singers, Biblical instruments.  * “song titles” need not be guessed exactly, but must contain the main words.",
                      "Christian and Christian-friendly books and movies, as well as the books of the Bible.",
                      "Biblical and/or Jewish feasts, Christian holidays, as well as food and drink mentioned in the Bible.",
                      "Religious artifacts throughout history and the names of Catholic Saints.",
                      "Words and phrases of the prophetic last book of the Bible.",
                      "The names of the Angels from the Bible and from Christian-Judeo mythology.",
                      "Christian denominations, beliefs and practices within different denominations, words associated with different denominations.",
                      "Transgressions described by the Bible and/or the Church.  * answers with more than one word need not be guessed exactly, but must contain the main words.",
                      "Words of Biblical mandates  * answers with more than one word need not be guessed exactly, but must contain the main words."]
    

    
    // MARK: - Transition Managers
    let gameScreenTransitionManager = GameScreenTransitionManager()
    let categoryScreenTransitionManager = CategoriesTransitionManager()

    
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the Select button.
        self.selectButton.layer.cornerRadius = 7
        self.selectButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.selectButton.layer.borderWidth = 3
        
        setCategory(categoryTapped)
        setColor(categoryTapped)
        setDescription(categoryTapped)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startAnimations()
    }
    

    // ******************************************** MARK: Additional Methods ********************************************* //
    
    func setCategory(category: Int) {
        titleLabel.text = titles[category]
    }
    
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    func setDescription(category: Int) {
        self.descriptionViewLabel.text = descriptions[category]
    }
    
    
    // MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToGame" {
           
            let toViewController = segue.destinationViewController as! GameViewController
            
            // Pass it the game object. 
            toViewController.game = self.game
            
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
        }
    }
    
    
    // MARK: - Animations

    
    func startAnimations() {
        
        UIView.animateWithDuration(0.2, delay: 0.2,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.TitleView.center.x -= self.view.bounds.width
                                 
        }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.4,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    self.descriptionView.center.x -= self.view.bounds.width
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.2, delay: 0.6,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                    self.selectButton.center.y -= self.view.bounds.width
                                    
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.8,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    
                                   self.backButtonView.alpha = 1.0
                                    
            }, completion: nil)
    }
    
} // END
