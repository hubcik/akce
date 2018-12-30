//
//  ItemVisited+CoreDataProperties.swift
//  AKCE
//
//  Created by Hubert Gostomski on 30/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemVisited {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemVisited> {
        return NSFetchRequest<ItemVisited>(entityName: "ItemVisited")
    }

    @NSManaged public var viewURL: String?

}
