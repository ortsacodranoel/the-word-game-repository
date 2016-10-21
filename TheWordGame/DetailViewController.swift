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

class DetailViewController: UIViewController, IAPManagerDelegate, UIApplicationDelegate {
    
    // MARK: - Variables
    var categoryTapped = Int()
    var backgroundColor = UIColor()
    var purchasedCategory:Bool!
    
    // MARK: - View Outlets
    @IBOutlet weak var categoryTitleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var lockView: UIView!
    @IBOutlet var mainView: UIView!
    
    // MARK: - Button Outlets
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    // MARK: - Labels
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Transition Managers
    let gameScreenTransitionManager = GameScreenTransitionManager()
    let categoryScreenTransitionManager = CategoriesTransitionManager()
    
    // Used by GameViewController to determine if a segue occured from this VC.
    var fromDetailVC:Bool!
    
    // Used to check internet reachability.
    var reachability: Reachability?
    
    
    
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.sharedInstance.delegate = self
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
    
    

    ///
    func reachabilityChanged(notification: NSNotification) {
        print("Status changed")
        //          reachability = notification.object as? Reachability
        //          self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }
    
    
    
    
    ///
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        
        var networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        var statusString: String = ""
        
        print("StatusValue: \(networkStatus)")
        
        if networkStatus == NotReachable {
            print("Netowrk is not reachable")
            reachabilityStatus = kNorReachable
        }
        else if networkStatus == ReachableViaWiFi {
            print("Via WIFI")
            reachabilityStatus = kReachabilityWithWiFi
        }
        else if networkStatus == ReachableViaWWAN {
            print("WAN reachable")
            reachabilityStatus  = kReachableWithWWAN
        }
    }
    
    
    
    // MARK: - Button Actions.
    @IBAction func backButtonTapped(_ sender: AnyObject)  {
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    
    /** 
     Touching the select button will segue to the game screen if the categories
     are free; else, it will create a payment request for that category product.
    **/
    @IBAction func selectButtonTapped(_ sender: AnyObject) {
        
            Game.sharedGameInstance.segueFromDetailVC = true

            if (sender.isTouchInside != nil) {
            self.tapAudioPlayer.play()
        }
        
        let title = self.categoryTitleLabel.text! as String
        
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
            
            
            reachability = Reachability.forInternetConnection()
            reachability?.startNotifier()
            
            NotificationCenter.default.addObserver(self, selector:#selector(reachabilityChanged(notification:)), name:NSNotification.Name("kReachabilityChangedNotification"), object:nil)
            NotificationCenter.default.post(name:NSNotification.Name("kReachabilityChangedNotification"), object: nil)

            
            
            if reachability != nil
            {
                self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
            }
            
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kReachabilityChangedNotification"), object: nil);
            
            // Check if connected to the internet.
            
            let networkStatus: NetworkStatus = reachability!.currentReachabilityStatus()

            if networkStatus == NotReachable {
                print("you must connect to the internet")
            } else {
            
                
                if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") {
                    self.selectButton.setTitle("Select", for: UIControlState())
                    performSegue(withIdentifier: "segueToGame", sender: self)
                } else {
                    IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 0) as! SKProduct)
                }
            }
            
        case "Books and Movies":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.books") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 1) as! SKProduct) // Books
            }
        case "Christian Nation":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 2) as! SKProduct) // Christian Nation
            }
        case "Christmas Time":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 3) as! SKProduct) // Christmas Time
            }
        case "Commands":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 4) as! SKProduct)  // Commands
            }
        case "Denominations":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 5) as! SKProduct) // Denominations
            }

        case "Easter":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.easter") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 6) as! SKProduct) // Easter
            }
            
            
        case "Famous Christians":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 7) as! SKProduct) // Famous Christians
            }
            
        case "Feasts":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") {
                
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 8) as! SKProduct) // Feasts
            }
        case "History":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.history") {
                
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 9) as! SKProduct) // History
            }
            
        case "Kids":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.kids") {
                
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 10) as! SKProduct)  // Kids
            }
            
        case "Relics and Saints":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 11) as! SKProduct)  // Relics
            }
        case "Revelation":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 12) as! SKProduct) // Revelation
            }
        case "Sins":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 13) as! SKProduct) // Sins
            }
        case "Worship":
            if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") {
                performSegue(withIdentifier: "segueToGame", sender: self)
            } else {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 14) as! SKProduct) // Worship
            }
        default:
            break
        }
    }
    

    
    func setPrices() {
        let title = self.categoryTitleLabel.text! as String
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
        case "Easter":
            let product = IAPManager.sharedInstance.products[6] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Famous Christians":
            let product = IAPManager.sharedInstance.products[7] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Feasts":
            let product = IAPManager.sharedInstance.products[8] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "History":
            let product = IAPManager.sharedInstance.products[9] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Kids":
            let product = IAPManager.sharedInstance.products[10] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Relics and Saints":
            let product = IAPManager.sharedInstance.products[11] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Revelation":
            let product = IAPManager.sharedInstance.products[12] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Sins":
            let product = IAPManager.sharedInstance.products[13] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        case "Worship":
            let product = IAPManager.sharedInstance.products[14] as! SKProduct
            self.selectButton.setTitle(("$\(product.price)"), for: UIControlState())
        default:
            break
        }
    }
    

    

     //MARK: Additional Methods
    func setCategory(_ category: Int) {
        categoryTitleLabel.text = Game.sharedGameInstance.categoriesArray[category].title
    }
    
    func setColor(_ category: Int) {
        //self.view.backgroundColor = Game.sharedGameInstance.colors[category]
        self.view.backgroundColor = Game.sharedGameInstance.gameColor
    }
    
    func setDescription(_ category: Int) {
       self.descriptionLabel.text = Game.sharedGameInstance.categoriesArray[category].summary
    }

    /// Segue to game.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGame" {
            let toViewController = segue.destination as! GameViewController
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
            
            self.removeAnimations()
        }
    }
    
    

    // MARK: - Animations
    
    /// Used to animate all objects when detailVC first loads.
    func startAnimations() {
        UIView.animate(withDuration: 0.2, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.categoryTitleView.alpha = 1
            self.categoryTitleView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.descriptionView.alpha  = 1
            self.descriptionView.center.x -=  self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.selectButtonView.alpha = 1
            self.selectButtonView.center.y -= self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.backButton.alpha = 1
        }, completion: nil)
    }
    
    
    func removeAnimations() {
        UIView.animate(withDuration: 0.2, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.categoryTitleView.center.x -= self.view.bounds.width - self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.4,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.descriptionView.center.x -= self.view.bounds.width - self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.6,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.selectButtonView.center.y -= self.view.bounds.width - self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            self.backButton.alpha = 0
            }, completion: nil)
    }

    

    /// MARK: - Lock animations.
    func lockCategory() {
            UIView.animate(withDuration: 0.5, delay:0.8,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lockView.alpha = 1
                }, completion: nil)
    }
    
    func unlockCategory() {
        UIView.animate(withDuration: 0.8, delay:0.8
            ,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.lockView.alpha = 0
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
    
    
    
}
