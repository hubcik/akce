//
//  CoreDataManager.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    private static var sharedCoreDataManager: CoreDataManager = {
        let coreDataManager = CoreDataManager()
        
        return coreDataManager
    }()
    
    class func shared() -> CoreDataManager {
        return sharedCoreDataManager
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    public override init() {
        
        super.init()
        
        let coordinator: NSPersistentStoreCoordinator? = self.persistentStoreCoordinator
        
        if coordinator != nil {
            self.managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            self.managedObjectContext?.persistentStoreCoordinator = coordinator
        }
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL:URL? = Bundle.main.url(forResource: "AKCE", withExtension: "momd")
        
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator = {
        let storeUrl:URL! = applicationDocumentsDirectory().appendingPathComponent("AKCE.sqlite")
        
        let psc:NSPersistentStoreCoordinator! = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true])
        }
        catch {
            abort()
        }
        
        return psc
        
    }()
    
    func saveContext() -> Void {
        
        let managedObjectContext: NSManagedObjectContext! = self.managedObjectContext
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch{
                abort()
            }
        }
    }
    
    func applicationDocumentsDirectory() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory: URL = (urls.first)!
        
        return documentDirectory
    }
}
