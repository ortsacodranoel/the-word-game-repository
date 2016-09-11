//
//  IAPManager.swift
//  testing-animations
//
//  Created by Leo on 9/5/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPManagerDelegate{
    func managerDidRestorePurchases()

}


class IAPManager: NSObject, SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate {
    
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:NSArray!
    
    var delegate:IAPManagerDelegate?
    
    /// Loads product identifiers for store usage.
    func setupInAppPurchases() {
        self.validateProductIdentifiers(self.getProductIdentifiersFromMainBundle())
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    /// Get product identifiers.
    func getProductIdentifiersFromMainBundle() ->NSArray {
        var identifiers = NSArray()
        if let url = NSBundle.mainBundle().URLForResource("iap_product_ids", withExtension: "plist") {
            identifiers = NSArray(contentsOfURL: url)!
        }
        
        return identifiers
        
    }
    
    /// Retrieve product information.
    func validateProductIdentifiers(identifiers:NSArray) {
        let productIdentifiers = NSSet(array: identifiers as [AnyObject])
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        self.request = productRequest
        productRequest.delegate = self
        productRequest.start()
    }
    
    
    /// Create payment request for product.
    func createPaymentRequestForProduct(product:SKProduct){
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1

        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    
    
    func productsRequest(request:SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
    }
    
    
    
    //MARK: SKPaymentTransactionObserver Delegate Protocol
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //
        for transaction in transactions as [SKPaymentTransaction]{
            switch transaction.transactionState{
            case .Purchasing:
                print("Purchasing")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                
            case .Deferred:
                print("Deferrred")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                print("Failed")
                print(transaction.error?.localizedDescription)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case.Purchased:
                print("Purchased")
                
                self.verifyReceipt(transaction)
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
        
        // Find the receipt.
        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL!
        
        // Check if NSData object can be created.
        if let receipt = NSData(contentsOfURL: receiptURL){
            
            // If the receipt exists we want to create a JSON object to send to apple for varification.
            
            // The request content will equal the receipt data encoded in a Base64 string.
            let requestContents = ["receipt-data" : receipt.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)), "password" : "326200e390c84cda8f7fb53750b72e05"]
            
            // Build a request.
            do {
                
                // JSON serialize the request content.
                let requestData = try NSJSONSerialization.dataWithJSONObject(requestContents, options: NSJSONWritingOptions(rawValue: 0))
                
                // Build URL Mutable Request.
                let storeURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
                let request = NSMutableURLRequest(URL: storeURL!)
                request.HTTPMethod = "Post"
                request.HTTPBody = requestData
                
                // Create the session.
                let session = NSURLSession.sharedSession()
               
                // Create the data task.
                let task = session.dataTaskWithRequest(request, completionHandler: { (responseData:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableLeaves) as! NSDictionary
                        
                        // Take a look at the receipt.
                        print(json)
                        
                        // Check if the receipt that we received is valid. The 0 means it's valid and we can further process that receipt.
                        if (json.objectForKey("status") as! NSNumber) == 0 {

                            if let latest_receipt = json["latest_receipt_info"]{
                                self.validatePurchaseArray(latest_receipt as! NSArray)
                            } else {
                                let receipt_dict = json["receipt"] as! NSDictionary
                                if let purchases = receipt_dict["in_app"] as? NSArray{
                                    self.validatePurchaseArray(purchases)
                                }
                            }
                            
                            
                            if transaction != nil {
                                SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
                            }
                            
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                self.delegate?.managerDidRestorePurchases()
                            })
                            
                        } else {
                            //Debug the receipt
                            print(json.objectForKey("status") as! NSNumber)
                        }
                        
                    } catch {
                        
                        print("JSON error:\(error)")
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
        
        let categoryToUnlock = Game.sharedGameInstance.getCategoryForProductKey(productIdentifier)
        categoryToUnlock.purchased = true
    }
    
    
    /// MARK: - Restore functions
    func restorePurchases() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
    func requestDidFinish(request: SKRequest) {
        self.verifyReceipt(nil)
    }
    
    
    
    
}