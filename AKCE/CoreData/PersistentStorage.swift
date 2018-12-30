//
//  PersistentStorage.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import Foundation
import CoreData

class PersistentStorage: NSObject {

    private static var sharedPersistentStorage: PersistentStorage = {
        let persistentStorage = PersistentStorage()
        
        return persistentStorage
    }()
    
    class func shared() -> PersistentStorage {
        return sharedPersistentStorage
    }
    
    private var visitedItems: [String] = []
    private var deletedItems: [String] = []
    
    public override init() {
        
        super.init()
        
        let fetchRequest_ItemsVisited = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest_ItemsVisited.entity = entityDescription_ItemVisited
        do {
            let result = try CoreDataManager.shared().managedObjectContext.fetch(fetchRequest_ItemsVisited)
            for case let mo as ItemVisited in result {
                visitedItems.append(mo.viewURL!)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        let fetchRequest_ItemsDeleted = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest_ItemsDeleted.entity = entityDescription_ItemDeleted
        do {
            let result = try CoreDataManager.shared().managedObjectContext.fetch(fetchRequest_ItemsDeleted)
            for case let mo as ItemDeleted in result {
                deletedItems.append(mo.viewURL!)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    public func isURLVisited(_ url: String) -> Bool {
        return self.visitedItems.contains(url)
    }
    
    public func isURLDeleted(_ url: String) -> Bool {
        return self.deletedItems.contains(url)
    }

    public func markURLVisited(_ url: String) {
        
        if self.visitedItems.contains(url) {
            return
        }
        
        self.visitedItems.append(url)
        
        let mo: ItemVisited = ItemVisited(entity: entityDescription_ItemVisited!, insertInto: CoreDataManager.shared().managedObjectContext)
        
        mo.viewURL = url
        
        self.saveChanges()
    }
    
    public func markURLDeleted(_ url: String) {

        if self.deletedItems.contains(url) {
            return
        }
        
        self.deletedItems.append(url)
        
        let mo: ItemDeleted = ItemDeleted(entity: entityDescription_ItemDeleted!, insertInto: CoreDataManager.shared().managedObjectContext)
        
        mo.viewURL = url
        
        self.saveChanges()
        
        //TODO: Deleted items COULD be remved from Visited.
    }
    
    private func saveChanges() {
        if CoreDataManager.shared().managedObjectContext.hasChanges {
            do {
                try CoreDataManager.shared().managedObjectContext.save()
            }
            catch {
                abort()
            }
        }
    }
}
