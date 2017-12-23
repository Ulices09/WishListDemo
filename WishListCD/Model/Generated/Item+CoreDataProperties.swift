//
//  Item+CoreDataProperties.swift
//  WishListCD
//
//  Created by Ulices Meléndez on 17/12/17.
//  Copyright © 2017 Ulices Meléndez Acosta. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var detail: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var image: Image?
    @NSManaged public var store: Store?
    @NSManaged public var type: ItemType?

}
