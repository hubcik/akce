//
//  SuperViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 30/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {

    lazy var activityView: UIView = {
        let av = UIView.init(frame: self.view.bounds)
        av.addSubview(self.activityIndicatorInternal)
        av.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        
        return av
    }()
    
    lazy var activityIndicatorInternal: NVActivityIndicatorView = {
        let ai = NVActivityIndicatorView(frame: CGRect.init(x: UIScreen.main.bounds.width / 2 - 15, y: UIScreen.main.bounds.height / 2 - 15, width: 30, height: 30), type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.init(white: 0.7, alpha: 1), padding: 0)
        ai.stopAnimating()
        
        return ai
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = COLOR_VIEWCONTROLLER_BACKGROUND
    }
    
    public func activityOn()
    {
        self.activityView.alpha = 0.8
        self.view.addSubview(self.activityView)
        self.activityIndicatorInternal.startAnimating()
    }
    
    public func activityOff()
    {
        DispatchQueue.main.async() {
            UIView.animate(withDuration: 0.3, animations: {
                self.activityView.alpha = 0.0
            }, completion: { (finished: Bool) in
                if finished {
                    self.activityIndicatorInternal.stopAnimating()
                    self.activityView.removeFromSuperview()
                }
            })
        }
    }

}
