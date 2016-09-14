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
    @IBOutlet weak var lock: UIView!
    
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
            UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1),
            UIColor(red: 190/255, green: 68/255, blue: 93/225, alpha: 1),
            UIColor(red: 196/255, green: 54/255, blue: 93/225, alpha: 1)
    ]


    
    
    // MARK: - Audio
    var buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    var tapAudioPlayer = AVAudioPlayer()
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOf: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }
    
    
    // MARK: - Transition Managers
    let gameScreenTransitionManager = GameScreenTransitionManager()
    let categoryScreenTransitionManager = CategoriesTransitionManager()


    // MARK: - Button Actions.
    @IBAction func backButtonTapped(_ sender: AnyObject)  {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    @IBAction func selectButtonTapped(_ sender: AnyObject) {
        if (sender.isTouchInside != nil) {
            self.tapAudioPlayer.play()
        }
        
        let title = self.titleLabel.text! as String
        
        switch title {
        case "Jesus":
            performSegue(withIdentifier: "segueToGame", sender: self)
        case "People":
            performSegue(withIdentifier: "segueToGame", sender: self)
        case "Places":
            performSegue(withIdentifier: "segueToGame", sender: self)
        case "Sunday School":
            performSegue(withIdentifier: "segueToGame", sender: self)
        case "Concordance":
            performSegue(withIdentifier: "segueToGame", sender: self)
        case "Angels":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 0) as! SKProduct)
            }
        case "Books and Movies":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.books") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 1) as! SKProduct)
            }
        case "Christian Nation":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 2) as! SKProduct)
            }
        case "Christmas Time":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 3) as! SKProduct)
            }
        case "Commands":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 4) as! SKProduct)
            }
        case "Denominations":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") {
                    performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 5) as! SKProduct)
            }
        case "Famous Christians":
                if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") {
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 6) as! SKProduct)
            }
        case "Feasts":
                if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") {
                    
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 7) as! SKProduct)
            }
        case "Relics and Saints":
                if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") {
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 8) as! SKProduct)
            }
        case "Revelation":
                if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") {
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 9) as! SKProduct)
            }
        case "Sins":
                if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") {
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 10) as! SKProduct)
            }
        case "Worship":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 11) as! SKProduct)
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
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Books and Movies":
            let product = IAPManager.sharedInstance.products[1] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Christian Nation":
            let product = IAPManager.sharedInstance.products[2] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Christmas Time":
            let product = IAPManager.sharedInstance.products[3] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Commands":
            let product = IAPManager.sharedInstance.products[4] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Denominations":
            let product = IAPManager.sharedInstance.products[5] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Famous Christians":
            let product = IAPManager.sharedInstance.products[6] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Feasts":
            let product = IAPManager.sharedInstance.products[7] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Relics and Saints":
            let product = IAPManager.sharedInstance.products[8] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Revelation":
            let product = IAPManager.sharedInstance.products[9] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Sins":
            let product = IAPManager.sharedInstance.products[10] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Worship":
            let product = IAPManager.sharedInstance.products[11] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure the Select button appearance.
        self.selectButton.layer.cornerRadius = 7
        self.selectButton.layer.borderColor = UIColor.white.cgColor
        self.selectButton.layer.borderWidth = 3
        
        setCategory(categoryTapped)
        setColor(categoryTapped)
        setDescription(categoryTapped)

        // Check to see if the category in the categoriesArray has been purchased.
        if (Game.sharedGameInstance.categoriesArray[categoryTapped].purchased == true)  {
            self.selectButton.setTitle(("Select"), for: UIControlState())
            //print("Active")
        } else {
            self.setPrices()
            self.lockCategory()
            self.setLockedColor()
        }
        startAnimations()
    }
    

     //MARK: Additional Methods
    func setCategory(_ category: Int) {
        titleLabel.text = Game.sharedGameInstance.categoriesArray[category].title
    }
    
    func setColor(_ category: Int) {
        self.view.backgroundColor = colors[category]
    }
    
    func setDescription(_ category: Int) {
        self.descriptionViewLabel.text = Game.sharedGameInstance.categoriesArray[category].summary
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGame" {
            let toViewController = segue.destination as! GameViewController
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
        }
    }
    
    
    
    
    
    // MARK: - Animations
    
    /// Used to animate all objects when detailVC first loads.
    func startAnimations() {
        UIView.animate(withDuration: 0.2, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.TitleView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.descriptionView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.selectButton.center.y -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
           self.backButtonView.alpha = 1.0
        }, completion: nil)
    }
    
    
    /// MARK: - Lock animations.
    func lockCategory() {
            UIView.animate(withDuration: 0.5, delay:0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lock.alpha = 1
                
                }, completion: nil)
    }
    
    func unlockCategory() {
        UIView.animate(withDuration: 0.8, delay:0.8
            ,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lock.alpha = 0
                self.setColor(self.categoryTapped)
            }, completion: nil)
    }
    
    func setLockedColor() {
        UIView.animate(withDuration: 1.0, delay:0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.view.backgroundColor = UIColor.darkGray
            }, completion: nil)
    }
    
    
    
    // MARK: - IAPManagerDelegate
    func managerDidRestorePurchases() {
        
        print("Purchase has been restored")
        self.unlockCategory()
        self.selectButton.setTitle(("Select"), for: UIControlState())
        Game.sharedGameInstance.categoriesArray[categoryTapped].purchased = true
        
    }
}
