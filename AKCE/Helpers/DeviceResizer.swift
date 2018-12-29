//
//  DeviceResizer.swift
//  AKCE
//
//  Created by Hubert Gostomski on 27/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

let cDesignScreenWidth:CGFloat = 320.0

class dr: NSObject {
    
    class func r(v: CGFloat) -> CGFloat
    {
        var resizeFactor:CGFloat = -1;
        
        if (resizeFactor < 0)
        {
            resizeFactor = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / cDesignScreenWidth
        }
        
        return ceil(resizeFactor * v)
    }
    
}
