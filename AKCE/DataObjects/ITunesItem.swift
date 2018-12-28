//
//  ITunesItem.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ITunesItem: NSObject {

    var itemId: NSInteger = 0
    var name: String = ""
    var imageURL: String = ""

    override public init() {
        super.init()
    }

    public init(itemDictionary: [String: Any]) {
        super.init()
    
        self.itemId = itemDictionary["trackId"] as! NSInteger
        self.name = itemDictionary["trackName"] as! String
        self.imageURL = itemDictionary["artworkUrl100"] as! String
    }
    
}
