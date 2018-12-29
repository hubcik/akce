//
//  ItemsVisited+CoreDataProperties.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemsVisited {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemsVisited> {
        return NSFetchRequest<ItemsVisited>(entityName: "ItemsVisited")
    }

    @NSManaged public var viewURL: String?

}
