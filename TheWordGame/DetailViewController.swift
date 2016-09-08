//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//
import UIKit
import AVFoundation

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
    
    
    // MARK: - Button Actions.
    @IBAction func backButtonTapped(sender: AnyObject)  {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }

    
    @IBAction func selectButtonTapped(sender: AnyObject) {
        if (sender.touchInside != nil) {
            self.tapAudioPlayer.play()
        }
    }
    

    // MARK: - Data.
    let titles = ["Jesus","People","Places","Sunday School","Concordance","Famous Christians","Worship","Books and Movies","Feasts","Relics and Saints","Revelation","Angels","Doctrine","Sins","Commands"]
    
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
            UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1)              // Commands
    ]
    

    
    
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
    let gameScreenTransitionManager = GameScreenTransitionManager()
    let categoryScreenTransitionManager = CategoriesTransitionManager()

    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sound.
        self.loadSoundFile()

        // Configure the Select button.
        self.selectButton.layer.cornerRadius = 7
        self.selectButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.selectButton.layer.borderWidth = 3
        
        setCategory(categoryTapped)
        setColor(categoryTapped)
        setDescription(categoryTapped)
    
        self.checkPurchase()
        
        

    
    }
    
    func checkPurchase() {
        
        let title = self.titleLabel.text! as String
    
        switch title {
        case "Jesus":
            self.selectButton.enabled = true
        case "People":
            self.selectButton.enabled = true
        case "Places":
            self.selectButton.enabled = true
        case "Sunday School":
            self.selectButton.enabled = true
        case "Concordance":
            self.selectButton.enabled = true
        case "Angels":
            self.checkUserDefaults("com.thewordgame.angels")
        case "Books":
            self.checkUserDefaults("com.thewordgame.books")
        case "Commands":
            self.checkUserDefaults("com.thewordgame.commands")
        case "Denominations":
            self.checkUserDefaults("com.thewordgame.denominations")
        case "Famous Christians":
            self.checkUserDefaults("com.thewordgame.famouschristians")
        case "Feasts":
            self.checkUserDefaults("com.thewordgame.feasts")
        case "Relics and Saints":
            self.checkUserDefaults("com.thewordgame.relics")
        case "Revelation":
            self.checkUserDefaults("com.thewordgame.revelation")
        case "Sins":
            self.checkUserDefaults("com.thewordgame.sins")
        case "Worship":
            self.checkUserDefaults("com.thewordgame.worship")
        default:
            break
        }
    
    }
    
    func checkUserDefaults(productCode: String) {
        
        // TODO: - Purchase check.
        if NSUserDefaults.standardUserDefaults().boolForKey(productCode) {
            self.selectButton.enabled = true
        } else {
            self.selectButton.enabled = false
            print("Category wasn't purchased")
        }
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
       // titleLabel.text = titles[category]
        titleLabel.text = Game.sharedGameInstance.categoriesArray[category].title

    }
    
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]

    }
    
    func setDescription(category: Int) {
        self.descriptionViewLabel.text = Game.sharedGameInstance.categoriesArray[category].summary
        
    }
    
    
    // MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        
        
        if segue.identifier == "segueToGame" {
           
            let toViewController = segue.destinationViewController as! GameViewController
        
            
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
