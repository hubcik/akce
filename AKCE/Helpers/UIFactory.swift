//
//  UIFactory.swift
//  AKCE
//
//  Created by Hubert Gostomski on 30/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class UIFactory: NSObject {

    class func createNameLabel() -> UILabel {
        
        let l: UILabel = UILabel(forAutoLayout:())
        l.backgroundColor = UIColor.clear
        l.textColor = COLOR_ITEM_NAME_FORE
        
        if Device.IS_IPHONE {
            l.font = UIFont.systemFont(ofSize: dr.r(v: 14))
        }
        else {
            l.font = UIFont.systemFont(ofSize: 22)
        }
        
        l.numberOfLines = 5
        l.textAlignment = NSTextAlignment.left
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.3
        
        return l
    }

    class func createNoResultsLabel() -> UILabel {
        
        let l: UILabel = UILabel(forAutoLayout:())
        l.backgroundColor = UIColor.clear
        l.textColor = COLOR_MESSAGE_NORESULTS
        l.font = UIFont.systemFont(ofSize: dr.r(v: 18))
        l.numberOfLines = 2
        l.textAlignment = NSTextAlignment.center
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.3
        
        l.text = NSLocalizedString("MSG_NoResults", comment: "")
        l.alpha = 0
        
        return l
    }
    
    class func createKindLabel() -> UILabel {
        
        let l: UILabel = UILabel(forAutoLayout:())
        l.backgroundColor = COLOR_ITEM_KIND_BACK
        l.textColor = COLOR_ITEM_KIND_FORE

        if Device.IS_IPHONE {
            l.font = UIFont.systemFont(ofSize: dr.r(v: 25))
        }
        else {
            l.font = UIFont.systemFont(ofSize: 30)
        }

        l.numberOfLines = 1
        l.textAlignment = NSTextAlignment.center
        l.adjustsFontSizeToFitWidth = false
        
        return l
    }
}
