//
//  RulesViewController.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit
import CoreData

class RulesViewController: UIViewController, IAPManagerDelegate {
    
    @IBOutlet weak var rulesScrollView: UIScrollView!
    @IBOutlet weak var settingsLabel: UILabel!
    var blurView:UIVisualEffectView!
    let rulesScreenTransitionManager = RulesTransitionManager()
    let swipeRecognizer = UISwipeGestureRecognizer()
    @IBOutlet weak var backgroundView: UIView!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var purchasedCategoriesEntity:PurchasedCategories!

    
    var reachability : Reachability?
    // Used to check network status.
    var networkStatus : NetworkStatus? = nil

    
    // MARK: - Network Methods
    func getNetworkStatus() {
        self.reachability = Reachability.forInternetConnection()
        self.reachability?.startNotifier()
        self.networkStatus = reachability!.currentReachabilityStatus()
    }
    

    // MARK: - Alert Views
    func connectToNetworkAlert() {
        let alertController = UIAlertController(title: "Network Required", message: "You must connect to the internet to restore your purchases. Please connect and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style:.default)
        alertController.addAction(okAction)
        self.present(alertController,animated:true, completion:nil)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.sharedInstance.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Settings", attributes: underlineAttribute)
        self.settingsLabel.attributedText = underlineAttributedString

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.blurView.frame = self.view.bounds
        self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.addSubview((self.blurView))
    }
    
    
    // MARK: - Button Actions
    @IBAction func rulesButtonTapped(_ sender: AnyObject) {
        if let url = URL(string: "http://www.thewordgameapp.com/official-rules-of-the-game/") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func restorButtonTapped(_ sender: AnyObject) {
        self.getNetworkStatus()
        if self.networkStatus  == NotReachable {
            self.connectToNetworkAlert()
        } else {
            IAPManager.sharedInstance.restorePurchases()
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    @IBAction func enableTutorialTapped(_ sender: AnyObject) {
        self.enablePopUps()
        self.performSegue(withIdentifier: "unwindToCategories", sender: self)
    }
    
    
    // MARK: - Tutorial Methods 
    func enablePopUps() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(true, forKey: "gameScreenEnabled")
        delegate.sharedTutorialEntity.setValue(true, forKey: "categoriesScreenEnabled")
        do {
            try context.save()
            Game.sharedGameInstance.showPopUp = true
        } catch {
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    
    // MARK: - CoreData Methods
    
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
//                    let fetchError = error as NSError
//                    print(fetchError)
                }
            }
        } catch {
//            let fetchError = error as NSError
//            NSLog("Unresolved error \(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func updatePurchasedCategoriesEntity() {
        if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") == true {
            self.purchasedCategoriesEntity.angels = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.books") == true {
            self.purchasedCategoriesEntity.booksAndMovies = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") == true {
            self.purchasedCategoriesEntity.christianNation = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") == true {
            self.purchasedCategoriesEntity.christmasTime = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") == true {
            self.purchasedCategoriesEntity.commands = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") == true {
            self.purchasedCategoriesEntity.denominations = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.easter") == true {
            self.purchasedCategoriesEntity.easter = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") == true {
            self.purchasedCategoriesEntity.famousChristians = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") == true {
            self.purchasedCategoriesEntity.feasts = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.history") == true {
            self.purchasedCategoriesEntity.history = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.kids") == true {
            self.purchasedCategoriesEntity.kids = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") == true {
            self.purchasedCategoriesEntity.relicsAndSaints = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") == true {
            self.purchasedCategoriesEntity.revelation = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") == true {
            self.purchasedCategoriesEntity.sins = true
            self.saveContext()
        }
        if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") == true {
            self.purchasedCategoriesEntity.worship = true
            self.saveContext()
        }
    }
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
               //  let nserror = error as NSError
               // NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - In-App Purchase Methods
    
    func managerDidRestorePurchases() {
        self.getPurchasedCategoryEntity()
        let alertController = UIAlertController(title: "In-App Purchase", message: "Your purchases have been restored", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style:.default,handler: { action in
            self.updatePurchasedCategoriesEntity()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
            self.present(vc!, animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        self.present(alertController,animated:true, completion:nil)
    }
    

    // MARK: - Swipe Gestures
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                performSegue(withIdentifier: "unwindToCategories", sender: self)
            default:
                break
            }
        }
    }
}

