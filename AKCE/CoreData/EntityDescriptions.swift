//
//  ViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import Foundation
import CoreData

let entityDescription_ItemVisited = NSEntityDescription.entity(forEntityName: "ItemVisited", in: CoreDataManager.shared().managedObjectContext)

let entityDescription_ItemDeleted = NSEntityDescription.entity(forEntityName: "ItemDeleted", in: CoreDataManager.shared().managedObjectContext)
