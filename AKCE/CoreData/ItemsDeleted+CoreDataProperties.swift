//
//  ItemsDeleted+CoreDataProperties.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemsDeleted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemsDeleted> {
        return NSFetchRequest<ItemsDeleted>(entityName: "ItemsDeleted")
    }

    @NSManaged public var viewURL: String?

}
