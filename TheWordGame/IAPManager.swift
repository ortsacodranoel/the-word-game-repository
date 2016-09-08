//
//  IAPManager.swift
//  testing-animations
//
//  Created by Leo on 9/5/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:NSArray!
    
    
    func setupInAppPurchases() {
        self.validateProductIdentifiers(self.getProductIdentifiersFromMainBundle())
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    
    func getProductIdentifiersFromMainBundle() ->NSArray {
        
        var identifiers = NSArray()
        
        // This will give us an array of product identifiers.
        if let url = NSBundle.mainBundle().URLForResource("iap_product_ids", withExtension: "plist") {
            identifiers = NSArray(contentsOfURL: url)!
        }
        
        return identifiers
        
    }
    
    
    func validateProductIdentifiers(identifiers:NSArray) {
        
        let productIdentifiers = NSSet(array: identifiers as [AnyObject])
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        
        self.request = productRequest
        productRequest.delegate = self
        productRequest.start()
    }
    
    
    func createPaymentRequestForProduct(product:SKProduct){
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    
    
    func productsRequest(request:SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
      //  print(self.products)
    }
    
    
    // MARK: SKPaymentTransactionObserver Protocol
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case .Purchasing:
                print("Purchasing")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            case .Deferred:
                print("Deferred")
                UIApplication.sharedApplication().networkActivityIndicatorVisible =  false
            case .Failed:
                print("Failed")
                UIApplication.sharedApplication().networkActivityIndicatorVisible =  false
                print(transaction.error?.localizedDescription)

            case .Purchased:
                print("Purchased")
            case .Restored:
                print("Restored")
            }
        }
    }
    
    func validatePurchaseArray(purchases:NSArray){
        
        for purchase in purchases as! [NSDictionary]{
            self.unlockPurchasedFunctionalityforProductIdentifier(purchase["product_id"] as! String)
        }
    }
    
    
    
    func verifyReceipt(transaction:SKPaymentTransaction?){
        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL!
        if let receipt = NSData(contentsOfURL: receiptURL){
            //Receipt exists
            let requestContents = ["receipt-data" : receipt.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))]
            
            //Perform request
            do {
                let requestData = try NSJSONSerialization.dataWithJSONObject(requestContents, options: NSJSONWritingOptions(rawValue: 0))
                
                //Build URL Request
                let storeURL = NSURL(string: "https:/sandbox.itunes.apple.com/verifyReceipt")
                let request = NSMutableURLRequest(URL: storeURL!)
                request.HTTPMethod = "Post"
                request.HTTPBody = requestData
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { (responseData:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    //
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableLeaves) as! NSDictionary
                        
                        print(json)
                        
                        if (json.objectForKey("status") as! NSNumber) == 0 {
                            //
                            let receipt_dict = json["receipt"] as! NSDictionary
                            if let purchases = receipt_dict["in_app"] as? NSArray{
                                self.validatePurchaseArray(purchases)
                            }
                            
                            if transaction != nil {
                                SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
                            }
                        } else {
                            //Debug the receipt
                            print(json.objectForKey("status") as! NSNumber)
                        }
                        
                    } catch {
                        print(error)
                    }
                })
                
                task.resume()
                
            } catch {
                print(error)
            }
            
        } else {
            //Receipt does not exist
            print("No Receipt")
        }
    }

    
    
    func unlockPurchasedFunctionalityforProductIdentifier(productIdentifier:String){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: productIdentifier)
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    
}