//
//  PurchasedCategories+CoreDataProperties.swift
//  TheWordGame
//
//  Created by Leo on 10/22/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import CoreData


extension PurchasedCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurchasedCategories> {
        return NSFetchRequest<PurchasedCategories>(entityName: "PurchasedCategories");
    }

    @NSManaged public var worship: Bool
    @NSManaged public var sins: Bool
    @NSManaged public var revelation: Bool
    @NSManaged public var relicsAndSaints: Bool
    @NSManaged public var kids: Bool
    @NSManaged public var history: Bool
    @NSManaged public var feasts: Bool
    @NSManaged public var famousChristians: Bool
    @NSManaged public var easter: Bool
    @NSManaged public var denominations: Bool
    @NSManaged public var commands: Bool
    @NSManaged public var christmasTime: Bool
    @NSManaged public var christianNation: Bool
    @NSManaged public var booksAndMovies: Bool
    @NSManaged public var angels: Bool
    @NSManaged public var concordance: Bool
    @NSManaged public var sundaySchool: Bool
    @NSManaged public var places: Bool
    @NSManaged public var people: Bool
    @NSManaged public var jesus: Bool

}
