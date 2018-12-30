//
//  ItemCollectionViewCell.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    var constraintsSet: Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var backgroundViewWithColor:UIView = {
        
        let b:UIView = UIView(forAutoLayout:())
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = COLOR_ITEM_BACK
        b.clipsToBounds = true
        
        return b
    }()

    public var imageView: UIImageView = {
        
        let iv: UIImageView = UIImageView(frame: CGRect.zero)
        
        iv.backgroundColor = UIColor.yellow
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()

    lazy var nameLabel: UILabel = {
        
        var l: UILabel = UIFactory.createNameLabel()
        
        return l
    }()

    public override init(frame: CGRect) {

        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(self.backgroundViewWithColor)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.nameLabel)

        self.updateConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
                
        updateConstraints()
    }

    override func updateConstraints() {
        
        super.updateConstraints()

        if constraintsSet {
            return
        }
        
        self.backgroundViewWithColor.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: dr.r(v: 0))
        self.backgroundViewWithColor.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: dr.r(v: 0))
        self.backgroundViewWithColor.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: dr.r(v: 1))
        self.backgroundViewWithColor.autoPinEdge(.bottom, to: .bottom, of: self.contentView, withOffset: dr.r(v: -1))

        if Device.IS_IPHONE {
            self.imageView.autoPinEdge(.left, to: .left, of: self.backgroundViewWithColor, withOffset: dr.r(v: 15))
            self.imageView.autoPinEdge(.top, to: .top, of: self.backgroundViewWithColor, withOffset: dr.r(v: 15))
            self.imageView.autoPinEdge(.bottom, to: .bottom, of: self.backgroundViewWithColor, withOffset: dr.r(v: -15))
        }
        else {
            self.imageView.autoPinEdge(.left, to: .left, of: self.backgroundViewWithColor, withOffset: 5)
            self.imageView.autoPinEdge(.top, to: .top, of: self.backgroundViewWithColor, withOffset: 5)
            self.imageView.autoPinEdge(.bottom, to: .bottom, of: self.backgroundViewWithColor, withOffset: -5)
        }
        self.imageView.autoMatch(.width, to: .height, of: self.imageView)

        self.nameLabel.autoPinEdge(.left, to: .right, of: self.imageView, withOffset: dr.r(v: 10))
        self.nameLabel.autoPinEdge(.right, to: .right, of: self.backgroundViewWithColor, withOffset: dr.r(v: -5))
        self.nameLabel.autoPinEdge(.top, to: .top, of: self.backgroundViewWithColor, withOffset: dr.r(v: 5))
        self.nameLabel.autoPinEdge(.bottom, to: .bottom, of: self.backgroundViewWithColor, withOffset: dr.r(v: -5))
        
        constraintsSet = true
    }

    public func setItem(_ item: ITunesItem) {
        
        self.imageView.loadImageAsync(with: item.imageURL)
        
        self.nameLabel.text = item.name
        
        if item.isVisited {
            self.backgroundViewWithColor.backgroundColor = COLOR_ITEM_BACK_VISTED
        }
        else {
            self.backgroundViewWithColor.backgroundColor = COLOR_ITEM_BACK
        }
    }

    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
