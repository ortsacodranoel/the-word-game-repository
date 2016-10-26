//
//  ViewController.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit
import CoreData

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    fileprivate var lastContentOffset: CGFloat = 0
    
    // MARK: - View Properties
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var settingsButton: UIButton!

    // MARK: - Timer Properties
    /// Used to delay the tutorialView animation.
    var popSoundTimer = Timer()

    // MARK: Button Properties
    @IBOutlet weak var rulesButton: UIButton!
    
    // MARK: - Transition Manager Properties
    let transitionManager = TransitionManager()
    let rulesScreenTransitionManager = RulesTransitionManager()
    
    // MARK: - Audio Properties
    
    // Used for tutorial pop up.
    var popSound = URL(fileURLWithPath: Bundle.main.path(forResource: "BubblePop", ofType: "mp3")!)
    var popAudioPlayer = AVAudioPlayer()
    
    // Used when button tapped.
    var tapSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonTapped", ofType: "wav")!)
    var tapAudioPlayer = AVAudioPlayer()
    
    
    // MARK: - CoreData Properties
    
    // Used to save boolean state that determines if tutorial is enabled.
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    
    // MARK: - Reachability Properties
    
    // Used to check internet reachability.
    var reachability: Reachability?
    
    var purchasedCategoriesEntity:PurchasedCategories!
    
    
    
    

    
    
    
    // MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Add gesture recognizer for tap on overlayView.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(CategoriesViewController.hideTutorialAction(sender:)))
        self.viewOverlay.addGestureRecognizer(tapGestureRecognizer)
        
        self.loadSoundFile()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.7, delay: 0.3,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.settingsButton.alpha = 1
            },completion:nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.reloadData()
        self.animatePopUpTutorial()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Core data categories
    func retrieveCoredataCategoryEntities() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(false, forKey: "categoriesScreenEnabled")
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    
    

    
    // MARK: - Tutorial methods
    
    /// Used to check if tutorial is enabled.
    func isTutorialEnabled() -> Bool {
        let sharedTutorialInstance = (UIApplication.shared.delegate as! AppDelegate).sharedTutorialEntity
        // Get the tutorial instance.
        let enabled = sharedTutorialInstance?.value(forKey: "categoriesScreenEnabled") as! Bool
        // Retrieve data.
        return enabled
    }
    
    
    /// Disable pop ups.
    func disablePopUps() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(false, forKey: "categoriesScreenEnabled")
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

    // Used to animate the `tutorialView` onScreen.
    func animatePopUpTutorial() {
        if isTutorialEnabled() {
            
            // Timer to play pop sound.
            if !self.popSoundTimer.isValid {
                self.popSoundTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(CategoriesViewController.playPopSound), userInfo:nil, repeats: false)
            }
            
            // Move tutorialView offScreen so it can be animated onScreen.
            self.tutorialView.center.y += self.tutorialView.frame.size.height
            self.tutorialView.center.x -= self.tutorialView.frame.size.width
            
            // Change the color of the screen so tutorial pop up stands out.
            UIView.animate(withDuration: 0.4, delay: 0.5,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                self.viewOverlay.alpha = 0.8
                }, completion: nil)
          
            // Animate `tutorial` view onScreen.
            UIView.animate(withDuration: 0.4, delay:0.5,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                
                    self.tutorialView.alpha = 1
                    // Move the tutorial view right.
                    self.tutorialView.center.x += self.tutorialView.bounds.width
                    // Move the tutorial view up.
                    self.tutorialView.center.y -= self.tutorialView.bounds.height
                
                }, completion: nil )
            
            self.disablePopUps()
        }
    }
    
    
    
    
    
    
    
    // MARK: - Audio Methods.
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOf: self.tapSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
            self.popAudioPlayer = try AVAudioPlayer(contentsOf: self.popSound, fileTypeHint: "mp3")
            self.popAudioPlayer.prepareToPlay()
        } catch {
            print("Unable to load sound files.")
        }
    }

    
    func playPopSound() {
        // Play pop sound once the tutorial view animates.
        self.popAudioPlayer.play()
    }
    
    
    

    
    
    
    
    // MARK: - Button Actions
    
    @IBAction func unwindToCategories(_ segue: UIStoryboardSegue){
        self.collectionView.reloadData()
        // self.tapAudioPlayer.play()
        if Game.sharedGameInstance.showPopUp {
            self.animatePopUpTutorial()
        }
        Game.sharedGameInstance.showPopUp = false
    }
    

    @IBAction func settingsBtnTapped(_ sender: AnyObject) {
        self.tapAudioPlayer.play()
        performSegue(withIdentifier: "segueToSettings", sender: self)
    }
    
    
    /**
     Used to hide the tutorial bubble from view and fade out the overlay when
     the overlayView or bubbleView is tapped.
     */
    func hideTutorialAction(sender:UITapGestureRecognizer) {
        
        // Animate overlay off-screen.
        UIView.animate(withDuration: 0.7, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                // Increase the alpha of the view.
                self.viewOverlay.alpha = 0
            }, completion: nil)
        
        // Animate tutorialView off-screen.
        UIView.animate(withDuration: 0.5, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // Move the view into place.
            self.tutorialView.center.x -= self.view.bounds.width
            self.tutorialView.center.y += self.view.bounds.height
            
            }, completion: { (bool) in
                self.tutorialView.alpha = 0
                self.tutorialView.center.x += self.view.bounds.width
                self.tutorialView.center.y -= self.view.bounds.height
        })
    }
    
    
    /// Needed for segue action.
    @IBAction func categoryButtonTapped(_ sender: AnyObject) {
        self.settingsButton.alpha = 0
    }
    
    
    
    
    
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.sharedGameInstance.categoriesArray.count
    }
    
    
    /// Setup categories.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure locks by looking at PurchasedCategories entity stored in MOC.
        let purchasedCategoriesFetchRequest : NSFetchRequest<PurchasedCategories>
        // Create a fetch request for all entities of type PurchasedCategories.
        if #available(iOS 10.0, OSX 10.12, *) {
            purchasedCategoriesFetchRequest = PurchasedCategories.fetchRequest()
            // Fetch request for newer iOS versions.
        } else {
            purchasedCategoriesFetchRequest = NSFetchRequest(entityName: "PurchasedCategories")
            // Fetch request for older iOS versions.
        }
        
        do {
            let purchasedCategoryEntities = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest)
            
            if purchasedCategoryEntities.count > 0 {
               // print("purchasedCategories entity exists in the MOC.")
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


        _ = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.categoryButton.layer.cornerRadius = 7
        cell.categoryButton.backgroundColor = Game.sharedGameInstance.colors[(indexPath as NSIndexPath).row]
        cell.tag = (indexPath as NSIndexPath).row
        cell.categoryButton.setTitle(Game.sharedGameInstance.categoriesArray[(indexPath as NSIndexPath).row].title, for: UIControlState())
        
        var category:Category!
        category =  Game.sharedGameInstance.categoriesArray[(indexPath as NSIndexPath).row]
        
        let title : String = category.title
        
        switch title {
        case "Jesus":
            cell.lockView.alpha = 0
        case "People":
            cell.lockView.alpha = 0
        case "Places":
            cell.lockView.alpha = 0
        case "Sunday School":
            cell.lockView.alpha = 0
        case "Concordance":
            cell.lockView.alpha = 0
        case "Angels":
            if self.purchasedCategoriesEntity.angels == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.angels == false{
                cell.lockView.alpha = 1
            }
        case "Books and Movies":
            if self.purchasedCategoriesEntity.booksAndMovies == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.booksAndMovies == false {
                cell.lockView.alpha = 1
            }
        case "Christian Nation":
            if self.purchasedCategoriesEntity.christianNation == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.christianNation == false {
                cell.lockView.alpha = 1
            }
        case "Christmas Time":
            if self.purchasedCategoriesEntity.christmasTime == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.christmasTime == false {
                cell.lockView.alpha = 1
            }
        case "Commands":
            if self.purchasedCategoriesEntity.commands == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.commands == false {
                cell.lockView.alpha = 1
            }
        case "Denominations":
            if self.purchasedCategoriesEntity.denominations == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.denominations == false{
                cell.lockView.alpha = 1
            }
        case "Easter":
            if self.purchasedCategoriesEntity.easter == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.easter == false {
                cell.lockView.alpha = 1
            }
        case "Famous Christians":
            if self.purchasedCategoriesEntity.famousChristians == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.famousChristians == false {
                cell.lockView.alpha = 1
            }
        case "Feasts":
            if self.purchasedCategoriesEntity.feasts == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.feasts == false {
                cell.lockView.alpha = 1
            }
        case "History":
            if self.purchasedCategoriesEntity.history == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.history == false {
                cell.lockView.alpha = 1
            }
        case "Kids":
            if self.purchasedCategoriesEntity.kids == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.kids == false {
                cell.lockView.alpha = 1
            }
        case "Relics and Saints":
            if self.purchasedCategoriesEntity.relicsAndSaints == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.relicsAndSaints == false {
                cell.lockView.alpha = 1
            }
        case "Revelation":
            if self.purchasedCategoriesEntity.revelation == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.revelation == false {
                cell.lockView.alpha = 1
            }
        case "Sins":
            if self.purchasedCategoriesEntity.sins == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.sins == false{
                cell.lockView.alpha = 1
            }
        case "Worship":
            if self.purchasedCategoriesEntity.worship == true {
                cell.lockView.alpha = 0
            } else if self.purchasedCategoriesEntity.worship == false {
                cell.lockView.alpha = 1
            }
        default:
            break
        }
        
        
        
//        reachability = Reachability.forInternetConnection()
//        reachability?.startNotifier()
//        
//        NotificationCenter.default.addObserver(self, selector:#selector(reachabilityChanged(notification:)), name:NSNotification.Name("kReachabilityChangedNotification"), object:nil)
//        NotificationCenter.default.post(name:NSNotification.Name("kReachabilityChangedNotification"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kReachabilityChangedNotification"), object: nil);
        
        // Check if connected to the internet.
        // let networkStatus: NetworkStatus = reachability!.currentReachabilityStatus()

        
        // MARK: - Configure categories
        
    
    
        
        
        
        
        
        
    
    
//        if networkStatus == NotReachable && indexPosition < 5  {
//            cell.lockView.alpha = 0
//        }
//        
//        else if networkStatus == NotReachable && indexPosition > 5 {
//            cell.lockView.alpha = 1
//        }
//        
//        
//        
//        // If there is no internet and the category wasn't bought.
//        if networkStatus == NotReachable && cell.lockView.alpha == 1 {
//            cell.lockView.alpha = 1
//        }
//       
//        // If there isn't internet and that category was bought.
//        else if networkStatus == NotReachable && category.purchased == true {
//            cell.lockView.alpha = 0
//        }
//            
//        // If online and category was purchased.
//        else if (networkStatus == ReachableViaWiFi || networkStatus == ReachableViaWWAN) && category.purchased == true {
//                cell.lockView.alpha = 0
//        }
//        
//        else if (networkStatus == ReachableViaWiFi || networkStatus == ReachableViaWWAN) && category.purchased == false {
//    
//                cell.lockView.alpha = 1
//        }
        
        return cell
    }
    
    
    
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "segueToRules" {
            self.tapAudioPlayer.play()
            let rulesViewController = segue.destination as! RulesViewController
            rulesViewController.transitioningDelegate = self.rulesScreenTransitionManager
       
        } else if segue.identifier == "segueToDetails" {
            // Fade rules if visible.
            self.rulesButton.alpha = 0
            
            // Retrieve the indexPath row.
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! CollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
          
            Game.sharedGameInstance.gameColor = Game.sharedGameInstance.colors[((indexPath! as NSIndexPath).row)]
            
            // Prepare destinationVC.
            let toViewController = segue.destination as! DetailViewController
            toViewController.categoryTapped = ((indexPath! as NSIndexPath).row)
            toViewController.transitioningDelegate = self.transitionManager
        }
    }



    
    // MARK: - Reachibility Methods
    
    
    ///
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        
        let networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
  //      var statusString: String = ""
        
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
    
    
    
    func reachabilityChanged(notification: NSNotification) {
   //     print("Status changed")
        //          reachability = notification.object as? Reachability
        //          self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }
    



}

















/**


 
 /// Animates the first tutorial step on screen load.
 func animateTutorialStep() {
 
 tutorialTimer.invalidate()
 
 print("in animate tutorial step")
 
 
 }
 
 
 
 

    // MARK: - Animations
    func animateMenuFadeIn() {
        UIView.animate(withDuration: 0.5,animations: {
            self.tutorialView.alpha = 1
            }, completion: nil)
    }



    func animateMenuFadeOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rulesButton.alpha = 0
            }, completion: nil)
    }





    /// Used to animate rules menu fade-in.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 30 {
            //self.rulesButton.setTitleColor(self.buttonBackgroundColor[1], forState: .Normal)
        }

        if scrollView.contentOffset.y > 30 {
            self.animateMenuFadeIn()
        } else if scrollView.contentOffset.y < 30 {
            self.animateMenuFadeOut()
        }
    }

*/
