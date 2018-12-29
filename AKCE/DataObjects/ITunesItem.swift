//
//  ITunesItem.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ITunesItem: NSObject {

    var kind: String? = ""
    var name: String? = ""
    var imageURL: String? = ""
    var viewURL: String? = ""
    
    var isVisited: Bool! = false

    override public init() {
        super.init()
    }

    public init(itemDictionary: [String: Any]) {
        super.init()
    
        self.kind = itemDictionary["kind"] as? String
        if self.kind == nil {
            self.kind = itemDictionary["wrapperType"] as? String
        }
        
        self.name = itemDictionary["trackName"] as? String
        if self.name == nil || self.name?.count == 0 {
            self.name = itemDictionary["collectionName"] as? String
        }
        
        self.imageURL = itemDictionary["artworkUrl100"] as? String
        if self.imageURL == nil {
            self.imageURL = itemDictionary["artworkUrl60"] as? String
            if self.imageURL == nil {
                self.imageURL = itemDictionary["artworkUrl30"] as? String
            }
        }
        
        if itemDictionary["collectionId"] != nil {
            self.viewURL = itemDictionary["collectionViewUrl"] as? String
        }
        else {
            self.viewURL = itemDictionary[(itemDictionary["wrapperType"] as! String) + "ViewUrl"] as? String
        }
        
        if self.viewURL != nil {
            self.isVisited = PersistentStorage.shared().isURLVisited(self.viewURL!)
        }
    }
    
    public func markVisited() {
        if self.viewURL != nil && !self.isVisited {
            self.isVisited = true
            PersistentStorage.shared().markURLVisited(self.viewURL!)
        }
    }
}
