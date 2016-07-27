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
    
    
    // MARK: - Buttons.
    @IBOutlet weak var selectButton: UIButton!
    

    
    // MARK: - Views.
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet var mainView: UIView!
    
    
    // MARK: - Labels.
    @IBOutlet weak var descriptionViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Actions.

    
    @IBAction func backButtonTapped(sender: AnyObject)  { }

    
    // MARK: - Data.
    let titles = ["JESUS","PEOPLE","PLACES", "FAMOUS", "WORSHIP", "BOOKS", "CONCORDANCE", "FEASTS", "ANGELS", "SUNDAY SCHOOL", "REVELATION", "DOCTRINE", "SINS", "COMMANDS"]
    
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
    
    let descriptions = ["HIS MANY NAMES, ADJECTIVES TO DESCRIBE HIS CHARACTER, AND WORDS ASSOCIATED WITH OUR LORD JESUS CHRIST.",
                        "THE MEN AND WOMEN OF WHOM THERE ARE STORIES IN THE BIBLE.",
                        "COUNTRIES, CITIES, LANDS, BODIES OF WATER, GEOLOGICAL LANDMARKS, AND MAN-MADE STRUCTURES IN AND OF THE TIMES OF THE BIBLE.",
                        "CHRISTIAN CELEBRITIES, TV EVANGELISTS, HISTORICAL AND INFLUENTIAL CHRISTIANS.",
                        "HYMNS, SONG OF WORSHIP, CHRISTIAN BANDS AND SINGERS, WORDS OF WORSHIP, AS WELL AS MUSICAL INSTRUMENTS FROM THE BIBLE. * IF THE ANSWER IS A SONG TITLE IN QUOTATION MARKS, YOUR TEAM DOES NOT HAVE TO GET THE EXACT TITLE, BUT IT MUST CONTAIN THE MAIN WORDS.",
                        "CHRISTIAN AND CHRISTIAN-FRIENDLY BOOKS AND MOVIES, AS WELL AS THE BOOKS OF THE BIBLE.",
                        "WORDS FOUND IN THE CONCORDANCE OF A BIBLE, EXCLUDING NAMES AND PLACES.",
                        "BIBLICAL AND CHRISTIAN HOLIDAYS AS WELL AS FOOD AND DRINK MENTIONED IN THE BIBLE.",
                        "THE NAMES OF THE ANGELS FROM THE BIBLE AND FROM CHRISTIAN-JUDEO MYTHOLOGY.",
                        "STORIES FROM THE BIBLE AS WELL AS JESUS’ PARABLES. * YOUR TEAM DOES NOT HAVE TO USE THE EXACT WORDS AS WRITTEN IN THE ANSWER, BUT MUST CLEARLY GUESS THE CORRECT BIBLE STORY. REMEMBER NOT TO SAY ANY PART OF THE ANSWER WHEN GIVING CLUES.",
                        "WORDS AND PHRASES OF THE PROPHETIC LAST BOOK OF THE BIBLE.",
                        "CHRISTIAN DENOMINATIONS, BELIEFS AND PRACTICES WITHIN DIFFERENT DENOMINATIONS, WORDS ASSOCIATED WITH DIFFERENT DENOMINATIONS.",
                        "WORDS OF BIBLICAL TRANSGRESSIONS. * ANSWERS WITH MORE THAN ONE WORD DO NOT HAVE TO BE GUESSED EXACTLY AS WRITTEN, BUT MUST CONTAIN THE MAIN WORDS.",
                        "WORDS OF BIBLICAL MANDATES. * ANSWERS WITH MORE THAN ONE WORD DO NOT HAVE TO BE GUESSED EXACTLY AS WRITTEN, BUT MUST CONTAIN THE MAIN WORDS."
                        ]
    
    // Create GameScreenTransitionManager to handle transition game screen.
    let gameScreenTransitionManager = GameScreenTransitionManager()
    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Gesture Recognizer to enable swiping back to Categories Menu.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.handleSwipes(_:)))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
       
        self.selectButton.setBackgroundImage(UIImage(named:"select_tapped"), forState: .Highlighted)
        
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
    
    
    // MARK: - Custom Methods.
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .Right) {
            performSegueWithIdentifier("unwindtToCategories", sender: self)
        }
    }
    
    func setCategory(category: Int) {
        titleLabel.text = titles[category]
    }
    
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    func setDescription(category: Int) {
        self.descriptionViewLabel.text = descriptions[category]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToGame" {
            let toViewController = segue.destinationViewController as! GameViewController
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
        }
    }
    

    
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
