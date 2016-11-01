//
//  IAPManager.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
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
    
    func setupInAppPurchases() {
        self.validateProductIdentifiers(self.getProductIdentifiersFromMainBundle())
        SKPaymentQueue.default().add(self)
    }
    
    func getProductIdentifiersFromMainBundle() ->NSArray {
        var identifiers = NSArray()
        if let url = Bundle.main.url(forResource: "iap_product_ids", withExtension: "plist") {
            identifiers = NSArray(contentsOf: url)!
        }
        
        return identifiers
    }
    
    func validateProductIdentifiers(_ identifiers:NSArray) {
        let productIdentifiers = NSSet(array: identifiers as [AnyObject])
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        self.request = productRequest
        productRequest.delegate = self
        productRequest.start()
    }
    
    
    func createPaymentRequestForProduct(_ product:SKProduct){
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1

        SKPaymentQueue.default().add(payment)
    }
    
    
    
    func productsRequest(_ request:SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products as NSArray!
    }
    
    
    
    //MARK: SKPaymentTransactionObserver Delegate Protocol
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction]{
            switch transaction.transactionState{
            case .purchasing:
               // print("Purchasing")
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .deferred:
            //    print("Deferrred")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            //    print("Failed")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case.purchased:
            //    print("Purchased")
                self.verifyReceipt(transaction)
            case .restored:
               print("Restored")
            }
        }
    }
    
    
    func validatePurchaseArray(_ purchases:NSArray){
            for purchase in purchases as! [NSDictionary]{
            self.unlockPurchasedFunctionalityforProductIdentifier(purchase["product_id"] as! String)
        }
    }
    
    
    
    func verifyReceipt(_ transaction:SKPaymentTransaction?){
        
        let receiptURL = Bundle.main.appStoreReceiptURL!
        
        if let receipt = try? Data(contentsOf: receiptURL){
            
            let requestContents = ["receipt-data" : receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)), "password" : "326200e390c84cda8f7fb53750b72e05"]
            
            // Build a request.
            do {
                
                // JSON serialize the request content.
                let requestData = try JSONSerialization.data(withJSONObject: requestContents, options: JSONSerialization.WritingOptions(rawValue: 0))
                
                // Build URL Mutable Request.
                let storeURL = URL(string: "https://buy.itunes.apple.com/verifyReceipt")
                
                // Create and configure the request.
                let request = NSMutableURLRequest(url: storeURL!)
                    request.httpMethod = "Post"
                    request.httpBody = requestData
                
                // Create the session.
                let session = URLSession.shared
               
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                        
                        // Check if the receipt that we received is valid. The 0 means it's valid and we can further process that receipt.
                        if (json.object(forKey: "status") as! NSNumber) == 0 {

                            if let latest_receipt = json["latest_receipt_info"]{
                                self.validatePurchaseArray(latest_receipt as! NSArray)
                            } else {
                                let receipt_dict = json["receipt"] as! NSDictionary
                                if let purchases = receipt_dict["in_app"] as? NSArray{
                                    self.validatePurchaseArray(purchases)
                                }
                            }
                            
                            
                            if transaction != nil {
                                SKPaymentQueue.default().finishTransaction(transaction!)
                            }
                            
                            DispatchQueue.main.sync(execute: { () -> Void in
                                self.delegate?.managerDidRestorePurchases()
                            })
                            
                        } else {
                            //Debug the receipt
                           // print(json.object(forKey: "status") as! NSNumber)
                        }
                        
                    } catch {
                        //print("JSON error:\(error)")
                    }
                })
                
                task.resume()
                
            } catch {
              //  print(error)
            }
            
        } else {
            //Receipt does not exist
           // print("No Receipt")
        }
    }
    
    
    func unlockPurchasedFunctionalityforProductIdentifier(_ productIdentifier:String){
        UserDefaults.standard.set(true, forKey: productIdentifier)
        UserDefaults.standard.synchronize()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let categoryToUnlock = Game.sharedGameInstance.getCategoryForProductKey(productIdentifier)
        categoryToUnlock.purchased = true
    }
    
    
    /// MARK: - Restore functions
    func restorePurchases() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
    func requestDidFinish(_ request: SKRequest) {
        self.verifyReceipt(nil)
    }
    
    
    
    
}
