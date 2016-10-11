//
//  TutorialPopUp+CoreDataProperties.swift
//  TheWordGame
//
//  Created by Daniel Castro on 10/9/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import CoreData


extension TutorialPopUp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TutorialPopUp> {
        return NSFetchRequest<TutorialPopUp>(entityName: "TutorialPopUp");
    }

    @NSManaged public var enabled: Bool

}
