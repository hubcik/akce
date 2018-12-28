//
//  ItemCollectionViewCell.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    lazy var backgroundViewWithColor:UIView = {
        let b:UIView = UIView(forAutoLayout:())
        b.backgroundColor = UIColor.green
        b.clipsToBounds = true
        
        return b
    }()

//    lazy var menuOptionLabel: UILabel = {
//        var tmpLabel:UILabel = UILabel(forAutoLayout:())
//        tmpLabel.backgroundColor = UIColor.clear
//        tmpLabel.font = UIFont(name: "SofiaPro-Medium", size: dr.r(v: 19))
//        tmpLabel.numberOfLines = 1
//        tmpLabel.textAlignment = NSTextAlignment.center
//        tmpLabel.adjustsFontSizeToFitWidth = true;
//        tmpLabel.minimumScaleFactor = 0.3
//
//        tmpLabel.text = ""
//
//        return tmpLabel;
//    }();

//    lazy var menuOptionImage: UIImageView = {
//        let iv: UIImageView = UIImageView.init(forAutoLayout: ())
//        iv.contentMode = .scaleAspectFit
//
//        return iv
//    }()

    public override init(frame: CGRect) {

        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(self.backgroundViewWithColor)
        
        self.updateConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        updateConstraints()
    }

    override func updateConstraints() {
        
        super.updateConstraints()

        self.backgroundViewWithColor.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.contentView, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(ALEdge.right, to: ALEdge.right, of: self.contentView, withOffset: dr.r(v: -5))
        self.backgroundViewWithColor.autoPinEdge(ALEdge.top, to: ALEdge.top, of: self.contentView, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(ALEdge.bottom, to: ALEdge.bottom, of: self.contentView, withOffset: dr.r(v: -5))

//        self.menuOptionImage.autoSetDimensions(to: CGSize.init(width: Dr.r(v: 55), height: Dr.r(v: 55)))
//        self.menuOptionImage.autoAlignAxis(.vertical, toSameAxisOf: self.backgroundViewWithColor)
//        self.menuOptionImage.autoPinEdge(ALEdge.top, to: ALEdge.top, of: self.backgroundViewWithColor, withOffset: Dr.r(v: 32) + iphoneXShift)
//
//        self.menuOptionLabel.autoPinEdge(.left, to: .left, of: self.backgroundViewWithColor, withOffset: Dr.r(v: 10))
//        self.menuOptionLabel.autoPinEdge(.top, to: .top, of: self.backgroundViewWithColor, withOffset: Dr.r(v: 105) + iphoneXShift)
//        self.menuOptionLabel.autoPinEdge(.right, to: .right, of: self.backgroundViewWithColor, withOffset: Dr.r(v: -10))
//        self.menuOptionLabel.autoSetDimension(.height, toSize: Dr.r(v: 26))
    }

    class func reuseIdentifier() -> String
    {
        return String(describing: self);
    }
}
