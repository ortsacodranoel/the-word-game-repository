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
import CoreData

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
    
    // Used to save boolean state that determines if tutorial is enabled.
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
   
    var purchasedCategoriesEntity:PurchasedCategories!
    
    var categoryKeys : [String: String] = [ "com.thewordgame.angels": "angels",
                                            "com.thewordgame.books": "booksAndMovies",
                                            "com.thewordgame.christiannation": "christianNation",
                                            "com.thewordgame.christmastime": "christmasTime",
                                            "com.thewordgame.commands": "commands",
                                            "com.thewordgame.denominations": "denominations",
                                            "com.thewordgame.easter": "easter",
                                            "com.thewordgame.famouschristians": "famousChristians",
                                            "com.thewordgame.feasts": "feasts",
                                            "com.thewordgame.history": "history",
                                            "com.thewordgame.kids": "kids",
                                            "com.thewordgame.relicsandsaints": "relicsAndSaints",
                                            "com.thewordgame.revelation": "revelation",
                                            "com.thewordgame.sins": "sins",
                                            "com.thewordgame.worship": "worship"]
    
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
        self.getPurchasedCategoryEntity()
        self.configureAppearance()
        self.startAnimations()
    }
    
    
    func configureAppearance() {
        // Configure the Select button appearance.
        self.selectButton.layer.cornerRadius = 7
        self.selectButton.layer.borderColor = UIColor.white.cgColor
        self.selectButton.layer.borderWidth = 3
        self.selectButton.showsTouchWhenHighlighted = false

        
        self.setCategory(categoryTapped)
        self.setColor(categoryTapped)
        self.setDescription(categoryTapped)
        
        // Check to see if the category in the categoriesArray has been purchased.
        if (Game.sharedGameInstance.categoriesArray[categoryTapped].purchased == true)  {
            self.selectButton.setTitle(("Select"), for: UIControlState())
        } else {
            self.setPrices()
            self.lockCategory()
            self.setLockedColor()
        }
    }
    
    
    func reachabilityChanged(notification: NSNotification) {
       // print("Status changed")
        //          reachability = notification.object as? Reachability
        //          self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }
    
    ///
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        let networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
    
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
    
    
    
    func updateEntityPurchasedCategories() {
        for (categoryKey, purchasedCategoryKey) in self.categoryKeys {
            if UserDefaults.standard.bool(forKey: categoryKey ) == true {
                self.purchasedCategoriesEntity.setValue(true, forKey: purchasedCategoryKey)
                self.saveContext()
            }
        }
    }



    // MARK: - Button Actions.
    @IBAction func backButtonTapped(_ sender: AnyObject)  {
        self.updateEntityPurchasedCategories()
        performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    /** 
     Touching the select button will segue to the game screen if the categories
     are free; else, it will create a payment request for that category product.
    **/
    @IBAction func selectButtonTapped(_ sender: AnyObject) {
    

        Game.sharedGameInstance.segueFromDetailVC = true

        // Internet Connection.
        reachability = Reachability.forInternetConnection()
        reachability?.startNotifier()
        NotificationCenter.default.addObserver(self, selector:#selector(reachabilityChanged(notification:)), name:NSNotification.Name("kReachabilityChangedNotification"), object:nil)
        NotificationCenter.default.post(name:NSNotification.Name("kReachabilityChangedNotification"), object: nil)
        if reachability != nil {
            self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kReachabilityChangedNotification"), object: nil);
        let networkStatus: NetworkStatus = reachability!.currentReachabilityStatus()
        
        self.getPurchasedCategoryEntity()
        
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
            
            // NO NETWORK + PURCHASED [FROM COREDATA]
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.angels == true
            {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                
            // NO NETWORK + NOT PURCHASED [FROM COREDATA]
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.angels == false
            {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            
            // NETWORK OK + APPLE PURCHASE TRUE
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") == true
            {
                // UPDATE COREDATA
                if self.purchasedCategoriesEntity.angels == false {
                    self.purchasedCategoriesEntity.angels = true
                    self.saveContext()
                }
                
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                
            // NETWORK OK + APPLE PURCHASE FALSE
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") == false
            {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 0) as! SKProduct)
            }
            
        // Books and movies
        case "Books and Movies":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.booksAndMovies == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.booksAndMovies == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.books") == true {
                if self.purchasedCategoriesEntity.booksAndMovies == false {
                    self.purchasedCategoriesEntity.booksAndMovies = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.books") == false
            {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 1) as! SKProduct)
            }
       
        // Christian Nation
        case "Christian Nation":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.christianNation == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.christianNation == false {
                // Display Alert View.
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") == true {
                if self.purchasedCategoriesEntity.christianNation == false {
                    self.purchasedCategoriesEntity.christianNation = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") == false
            {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 2) as! SKProduct)
            }
        case "Christmas Time":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.christmasTime == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.christmasTime == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") == true {
                if self.purchasedCategoriesEntity.christmasTime == false {
                    self.purchasedCategoriesEntity.christmasTime = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 3 ) as! SKProduct)
            }
        case "Commands":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.commands == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.commands == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") == true {
                if self.purchasedCategoriesEntity.commands == false {
                    self.purchasedCategoriesEntity.commands = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 4 ) as! SKProduct)
            }
        case "Denominations":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.denominations == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.denominations == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") == true {
                if self.purchasedCategoriesEntity.denominations == false {
                    self.purchasedCategoriesEntity.denominations = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 5 ) as! SKProduct)
            }
        case "Easter":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.easter == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.easter == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.easter") == true {
                if self.purchasedCategoriesEntity.easter == false {
                    self.purchasedCategoriesEntity.easter = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.easter") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 6 ) as! SKProduct)
            }
        case "Famous Christians":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.famousChristians == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.famousChristians == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") == true {
                if self.purchasedCategoriesEntity.famousChristians == false {
                    self.purchasedCategoriesEntity.famousChristians = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 7 ) as! SKProduct)
            }
        case "Feasts":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.feasts == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.feasts == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") == true {
                if self.purchasedCategoriesEntity.feasts == false {
                    self.purchasedCategoriesEntity.feasts = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 8 ) as! SKProduct)
            }
        case "History":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.history == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.history == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.history") == true {
                if self.purchasedCategoriesEntity.history == false {
                    self.purchasedCategoriesEntity.history = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.history") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 9 ) as! SKProduct)
            }

        case "Kids":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.kids == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.kids == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.kids") == true {
                if self.purchasedCategoriesEntity.kids == false {
                    self.purchasedCategoriesEntity.kids = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.kids") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 10 ) as! SKProduct)
            }

        case "Relics and Saints":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.relicsAndSaints == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.relicsAndSaints == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") == true {
                if self.purchasedCategoriesEntity.relicsAndSaints == false {
                    self.purchasedCategoriesEntity.relicsAndSaints = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 11 ) as! SKProduct)
            }
        case "Revelation":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.revelation == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.revelation == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") == true {
                if self.purchasedCategoriesEntity.revelation == false {
                    self.purchasedCategoriesEntity.revelation = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 12 ) as! SKProduct)
            }
        case "Sins":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.sins == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.sins == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") == true {
                if self.purchasedCategoriesEntity.sins == false {
                    self.purchasedCategoriesEntity.sins = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 13 ) as! SKProduct)
            }
        case "Worship":
            if networkStatus == NotReachable && self.purchasedCategoriesEntity.worship == true {
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
                // Display Alert View.
            else if networkStatus == NotReachable && self.purchasedCategoriesEntity.worship == false {
                let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to download this categroy. Please connect and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title:"OK", style:.default)
                alertController.addAction(okAction)
                self.present(alertController,animated:true, completion:nil)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") == true {
                if self.purchasedCategoriesEntity.worship == false {
                    self.purchasedCategoriesEntity.worship = true
                    self.saveContext()
                }
                self.selectButton.setTitle("Select", for: UIControlState())
                performSegue(withIdentifier: "segueToGame", sender: self)
            }
            else if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") == false {
                IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.object(at: 14 ) as! SKProduct)
            }
        default:
            break
        }
    }

    
    
    func setPrices() {
        let title = self.categoryTitleLabel.text! as String
        switch title {
        case "Angels":
            if self.purchasedCategoriesEntity.angels == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Books and Movies":
            if self.purchasedCategoriesEntity.booksAndMovies == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Christian Nation":
            if self.purchasedCategoriesEntity.christianNation == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Christmas Time":
            if self.purchasedCategoriesEntity.christmasTime == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Commands":
            if self.purchasedCategoriesEntity.commands == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Denominations":
            if self.purchasedCategoriesEntity.denominations == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Easter":
            if self.purchasedCategoriesEntity.easter == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Famous Christians":
            if self.purchasedCategoriesEntity.famousChristians == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Feasts":
            if self.purchasedCategoriesEntity.feasts == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "History":
            if self.purchasedCategoriesEntity.history == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Kids":
            if self.purchasedCategoriesEntity.kids == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Relics and Saints":
            if self.purchasedCategoriesEntity.relicsAndSaints == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Revelation":
            if self.purchasedCategoriesEntity.revelation == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Sins":
            if self.purchasedCategoriesEntity.sins == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        case "Worship":
            if self.purchasedCategoriesEntity.worship == false {
                self.selectButton.setTitle("$0.99",  for: UIControlState())
            }
        default:
            break
        }
    }
    
    
    // MARK: - CoreData
    
    /// Used to save any new changes to the managed object context.
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    
    /// Retrieves and assigns a `PurchasedCategory` entity to a local variable.
    func getPurchasedCategoryEntity() {
        let purchasedCategoriesFetchRequest : NSFetchRequest<PurchasedCategories>
        if #available(iOS 10.0, OSX 10.12, *) {
            purchasedCategoriesFetchRequest = PurchasedCategories.fetchRequest()
        } else {
            purchasedCategoriesFetchRequest = NSFetchRequest(entityName: "PurchasedCategories")
        }
        do {
            let purchasedCategoryEntities = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest)
            if purchasedCategoryEntities.count > 0 {
                do {
                    let purchasedCategoryEntitiesInMOC = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    if (purchasedCategoryEntitiesInMOC.count > 0) {
                        self.purchasedCategoriesEntity = purchasedCategoryEntitiesInMOC[0] as! PurchasedCategories
                    }
                } catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    //MARK: View configuration
    
    func setCategory(_ category: Int) {
        categoryTitleLabel.text = Game.sharedGameInstance.categoriesArray[category].title
    }
    
    func setColor(_ category: Int) {
        self.view.backgroundColor = Game.sharedGameInstance.gameColor
    }
    
    func setDescription(_ category: Int) {
       self.descriptionLabel.text = Game.sharedGameInstance.categoriesArray[category].summary
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGame" {
            let toViewController = segue.destination as! GameViewController
            toViewController.categoryTapped = self.categoryTapped
            toViewController.transitioningDelegate = self.gameScreenTransitionManager
            self.removeAnimations()
        }
    }
    
    

    // MARK: - Animations
    
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
        self.unlockCategory()
        self.selectButton.setTitle(("Select"), for: UIControlState())
        Game.sharedGameInstance.categoriesArray[categoryTapped].purchased = true
        self.updateEntityPurchasedCategories()
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
