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

    public var imageView: UIImageView = {
        let iv: UIImageView = UIImageView(frame: CGRect.zero)
        
        iv.backgroundColor = UIColor.black
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
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
        self.contentView.addSubview(self.imageView)

        self.updateConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        updateConstraints()
    }

    override func updateConstraints() {
        
        super.updateConstraints()

        self.backgroundViewWithColor.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: dr.r(v: -5))
        self.backgroundViewWithColor.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(.bottom, to: .bottom, of: self.contentView, withOffset: dr.r(v: -5))

        self.backgroundViewWithColor.autoPinEdge(.left, to: .left, of: self.backgroundViewWithColor, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(.top, to: .top, of: self.backgroundViewWithColor, withOffset: dr.r(v: 5))
        self.backgroundViewWithColor.autoPinEdge(.bottom, to: .bottom, of: self.backgroundViewWithColor, withOffset: dr.r(v: -5))
        self.backgroundViewWithColor.autoMatch(.width, to: .height, of: self.backgroundViewWithColor)
    }

    public func setItem(_ item: ITunesItem) {
        self.imageView.loadImageAsync(with: item.imageURL)
    }

    class func reuseIdentifier() -> String
    {
        return String(describing: self);
    }
}
