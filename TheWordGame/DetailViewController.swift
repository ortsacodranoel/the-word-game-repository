//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//
import UIKit
import AVFoundation
import StoreKit

class DetailViewController: UIViewController, IAPManagerDelegate {
    
    // MARK: - Variables
    var categoryTapped = Int()
    var backgroundColor = UIColor()
    
    // MARK: - Buttons
    @IBOutlet weak var selectButton: UIButton!

    // MARK: - Views
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    
    // MARK: - Labels
    @IBOutlet weak var descriptionViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var purchasedCategory:Bool!
    
    let colors = [
            UIColor(red: 147/255, green: 126/255, blue: 211/225, alpha: 1),
            UIColor(red: 62/255, green: 166/255, blue: 182/225, alpha: 1),
            UIColor(red: 202/255, green: 115/255, blue: 99/225, alpha: 1),
            UIColor(red: 215/255, green: 184/255, blue: 136/225, alpha: 1),
            UIColor(red: 55/255, green: 98/255, blue: 160/225, alpha: 1),
            UIColor(red: 163/255, green: 56/255, blue: 120/225, alpha: 1),
            UIColor(red: 199/255, green: 176/255, blue: 87/225, alpha: 1),
            UIColor(red: 159/255, green: 200/255, blue: 223/225, alpha: 1),
            UIColor(red: 48/255, green: 142/255, blue: 145/225, alpha: 1),
            UIColor(red: 178/255, green: 215/255, blue: 255/225, alpha: 1),
            UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),
            UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1),
            UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1),
            UIColor(red: 152/255, green: 221/255, blue: 217/225, alpha: 1),
            UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1)
    ]
    

    @IBOutlet weak var lock: UIView!
    
    
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


    // MARK: - Button Actions.
    @IBAction func backButtonTapped(sender: AnyObject)  {
        performSegueWithIdentifier("unwindToCategories", sender: self)
    }
    
    
    @IBAction func selectButtonTapped(sender: AnyObject) {
        // Tap sound.
        
        if (sender.touchInside != nil) {
            self.tapAudioPlayer.play()
        }
        
        let title = self.titleLabel.text! as String
        
        switch title {
            case "Jesus":
                performSegueWithIdentifier("segueToGame", sender: self)
            case "People":
                performSegueWithIdentifier("segueToGame", sender: self)
            case "Places":
                performSegueWithIdentifier("segueToGame", sender: self)
            case "Sunday School":
                performSegueWithIdentifier("segueToGame", sender: self)
            case "Concordance":
                performSegueWithIdentifier("segueToGame", sender: self)
            
        case "Angels":
        
            if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.angels") {
                self.selectButton.setTitle("Select", forState: .Normal)
                performSegueWithIdentifier("segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(0) as! SKProduct)
            }
        
        case "Books and Movies":
            if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.books") {
                performSegueWithIdentifier("segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(1) as! SKProduct)
            }
            
        case "Commands":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.commands") {
                
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(2) as! SKProduct)
                }
      
        case "Denominations":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.denominations") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(3) as! SKProduct)
            }
        case "Famous Christians":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.famouschristians") {
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(4) as! SKProduct)
            }
        
        case "Feasts":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.feasts") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(5) as! SKProduct)
            }
        
        case "Relics and Saints":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.relicsandstaints") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(6) as! SKProduct)
            }
        
        case "Revelation":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.revelation") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(7) as! SKProduct)
            }
        
        case "Sins":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.sins") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(8) as! SKProduct)
                    
            }
        
        case "Worship":
                if NSUserDefaults.standardUserDefaults().boolForKey("com.thewordgame.worship") {
                    
                    performSegueWithIdentifier("segueToGame", sender: self)
                    
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(9) as! SKProduct)
                    
            }
        default:
            break
        }
    }

    
    func setPrices() {
        let title = self.titleLabel.text! as String
        switch title {
        case "Angels":
         let product = IAPManager.sharedInstance.products[0] as! SKProduct
         self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
         
        case "Books and Movies":
            let product = IAPManager.sharedInstance.products[1] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Commands":
            let product = IAPManager.sharedInstance.products[2] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Denominations":
            let product = IAPManager.sharedInstance.products[3] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)

        case "Famous Christians":
            let product = IAPManager.sharedInstance.products[4] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Feasts":
            let product = IAPManager.sharedInstance.products[5] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Relics and Saints":
            let product = IAPManager.sharedInstance.products[6] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Revelation":
            let product = IAPManager.sharedInstance.products[7] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
            
        case "Sins":
            let product = IAPManager.sharedInstance.products[8] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
        
        case "Worship":
            let product = IAPManager.sharedInstance.products[9] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), forState: .Normal)
        
        default:
        break
        }
    }

    

    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.sharedInstance.delegate = self
        // Load sound.
        self.loadSoundFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure the Select button.
        self.selectButton.layer.cornerRadius = 7
        self.selectButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.selectButton.layer.borderWidth = 3
        
        setCategory(categoryTapped)
        setColor(categoryTapped)
        setDescription(categoryTapped)

        // Check to see if the category in the categoriesArray has been purchased.
        if (Game.sharedGameInstance.categoriesArray[categoryTapped].purchased == true)  {
            self.selectButton.setTitle(("Select"), forState: .Normal)
            print("Active")
        } else {
            self.setPrices()
            self.lockCategory()
        }

        
        startAnimations()
    }
    

     //MARK: Additional Methods
    func setCategory(category: Int) {
        titleLabel.text = Game.sharedGameInstance.categoriesArray[category].title
    }
    
    func setColor(category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    func setDescription(category: Int) {
        self.descriptionViewLabel.text = Game.sharedGameInstance.categoriesArray[category].summary
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToGame" {
            let toViewController = segue.destinationViewController as! GameViewController
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
        }
    }
    
    // MARK: - Animations
    func startAnimations() {
        UIView.animateWithDuration(0.2, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.TitleView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.descriptionView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.selectButton.center.y -= self.view.bounds.width
        }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
           self.backButtonView.alpha = 1.0
        }, completion: nil)
    }
    
    /// MARK: - Lock animations.
    func lockCategory() {
            UIView.animateWithDuration(0.5, delay:0.8
                ,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lock.alpha = 1
                }, completion: nil)
    }
    
    func unlockCategory() {
        UIView.animateWithDuration(0.5, delay:0.8
            ,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lock.alpha = 0
            }, completion: nil)
    }
    
    
    
    // MARK: - IAPManager
    func managerDidRestorePurchases() {
        print("Purchase has been restored")
        self.unlockCategory()
        self.selectButton.setTitle(("Select"), forState: .Normal)
        Game.sharedGameInstance.categoriesArray[categoryTapped].purchased = true

    }
}
