//
//  IAPManager.swift
//  testing-animations
//
//  Created by Leo on 9/5/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate {
    
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:NSArray!
    
    
    func setupInAppPurchases() {
        self.validateProductIdentifiers(self.getProductIdentifiersFromMainBundle())
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
    
    
    func productsRequest(request:SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
        print(self.products)
    }
    
}