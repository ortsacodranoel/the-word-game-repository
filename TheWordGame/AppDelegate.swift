//
//  AppDelegate.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import CoreData
import StoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var canPurchase:Bool = false
    var sharedTutorialEntity:NSManagedObject!
    var purchasedCategoriesSharedInstance:NSManagedObject!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.setupPurchasedCategoriesEntity()
        
        if SKPaymentQueue.canMakePayments(){
            canPurchase = true
            IAPManager.sharedInstance.setupInAppPurchases()
        }
        
        let fetchRequest : NSFetchRequest<TutorialPopUp>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetchRequest = TutorialPopUp.fetchRequest()
        } else {
            fetchRequest = NSFetchRequest(entityName: "TutorialPopUp")
        }
        
        do {
            
            let entities = try managedObjectContext.fetch(fetchRequest)
   
            if entities.count < 1 {
                
                let tutorial = NSEntityDescription.insertNewObject(forEntityName: "TutorialPopUp", into: self.managedObjectContext) as! TutorialPopUp
                
                tutorial.categoriesScreenEnabled = true
                tutorial.gameScreenEnabled = true
                try managedObjectContext.save()

                do {
                    let result = try self.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    
                    if (result.count > 0) {
                        self.sharedTutorialEntity = result[0] as! NSManagedObject
                        self.sharedTutorialEntity.setValue(true, forKey: "categoriesScreenEnabled")
                        self.sharedTutorialEntity.setValue(true, forKey: "gameScreenEnabled")
                    }
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
            
            } else if entities.count > 0 {
                do {
                    let result = try self.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    
                    if (result.count > 0) {
                        self.sharedTutorialEntity = result[0] as! NSManagedObject
                    }
                } catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return true
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.danielcastro.TheWordGame" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "thewordgame", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {

            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

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

    func setupPurchasedCategoriesEntity() {
        
        let purchasedCategoriesFetchRequest : NSFetchRequest<PurchasedCategories>
        if #available(iOS 10.0, OSX 10.12, *) {
            purchasedCategoriesFetchRequest = PurchasedCategories.fetchRequest()
        } else {
            purchasedCategoriesFetchRequest = NSFetchRequest(entityName: "PurchasedCategories")
        }
        
        do {
            
            let purchasedCategoryEntities = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest)
            
            if purchasedCategoryEntities.count < 1 {
                _ = NSEntityDescription.insertNewObject(forEntityName: "PurchasedCategories", into: self.managedObjectContext) as! PurchasedCategories
                try self.managedObjectContext.save()
               
                do {
                    
                    let result = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    if (result.count > 0) {
                        self.purchasedCategoriesSharedInstance = result[0] as! NSManagedObject
                        
                        self.purchasedCategoriesSharedInstance.setValue(true, forKey: "jesus")
                        self.purchasedCategoriesSharedInstance.setValue(true, forKey: "people")
                        self.purchasedCategoriesSharedInstance.setValue(true, forKey: "places")
                        self.purchasedCategoriesSharedInstance.setValue(true, forKey: "sundaySchool")
                        self.purchasedCategoriesSharedInstance.setValue(true, forKey: "concordance")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "angels")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "booksAndMovies")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "christianNation")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "christmasTime")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "commands")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "denominations")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "easter")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "famousChristians")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "feasts")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "history")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "kids")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "relicsAndSaints")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "revelation")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "sins")
                        self.purchasedCategoriesSharedInstance.setValue(false, forKey: "worship")
                        
                        self.saveContext()
                    }
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
            } else if purchasedCategoryEntities.count > 0 {
                
                do {
                    
                    let purchasedCategoryEntitiesInMOC = try self.managedObjectContext.fetch(purchasedCategoriesFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    if (purchasedCategoryEntitiesInMOC.count > 0) {
                        self.purchasedCategoriesSharedInstance = purchasedCategoryEntitiesInMOC[0] as! NSManagedObject
                    }
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                }
        } catch let error {
            print(error.localizedDescription)
        }
    }
 }

