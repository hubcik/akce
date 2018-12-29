//
//  ItemDetailsViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    var rightButton: UIBarButtonItem?
    weak var searchViewController: SearchViewController!

    public var imageView: UIImageView = {
        let iv: UIImageView = UIImageView(frame: CGRect.zero)
        
        iv.backgroundColor = UIColor.clear
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        var l: UILabel = UILabel(forAutoLayout:())
        l.backgroundColor = UIColor.clear
        l.textColor = COLOR_ITEM_NAME
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 5
        l.textAlignment = NSTextAlignment.left
        l.adjustsFontSizeToFitWidth = true;
        l.minimumScaleFactor = 0.3
        
        l.text = ""
        
        return l
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public init(withItem: ITunesItem, fromSearchViewController: SearchViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchViewController = fromSearchViewController
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = COLOR_VIEWCONTROLLER_BACKGROUND
        
        self.title = NSLocalizedString("ItemDetailsTitle", comment: "")
        
        self.rightButton = UIBarButtonItem(image: UIImage(named: "bt-delete"), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = self.rightButton

        self.view.addSubview(self.imageView)
        self.view.addSubview(self.nameLabel)

        self.imageView.loadImageAsync(with: withItem.imageURL)
        self.nameLabel.text = withItem.name
        
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.imageView.autoPinEdge(.left, to: .left, of: self.view, withOffset: dr.r(v: 15))
        self.imageView.autoPinEdge(.top, to: .top, of: self.view, withOffset: dr.r(v: 15))
        self.imageView.autoSetDimensions(to: CGSize(width: dr.r(v: 50), height: dr.r(v: 50)))
        
        self.nameLabel.autoPinEdge(.left, to: .right, of: self.imageView, withOffset: dr.r(v: 10))
        self.nameLabel.autoPinEdge(.right, to: .right, of: self.view, withOffset: dr.r(v: -5))
        self.nameLabel.autoPinEdge(.top, to: .top, of: self.imageView)
        self.nameLabel.autoPinEdge(.bottom, to: .bottom, of: self.imageView)
    }
    
    @objc func rightButtonTapped() -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("MessageTitle", comment: ""), message: NSLocalizedString("ConfirmDeleteItem", comment: ""), preferredStyle: .actionSheet)
        
        var action: UIAlertAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.searchViewController.deleteCurrentItem()
            self.navigationController?.popViewController(animated: true)
        })
        action.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(action)
        
        action = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: { (action:UIAlertAction) in
        })
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
