//
//  ItemDeleted+CoreDataProperties.swift
//  AKCE
//
//  Created by Hubert Gostomski on 30/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemDeleted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemDeleted> {
        return NSFetchRequest<ItemDeleted>(entityName: "ItemDeleted")
    }

    @NSManaged public var viewURL: String?

}
