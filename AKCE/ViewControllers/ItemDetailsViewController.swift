//
//  ItemDetailsViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 29/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit
import WebKit

class ItemDetailsViewController: SuperViewController {

    var rightButton: UIBarButtonItem?
    weak var searchViewController: SearchViewController!

    public var imageView: UIImageView = {
        
        let iv: UIImageView = UIImageView(frame: CGRect.zero)
        
        iv.backgroundColor = UIColor.clear
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()

    lazy var kindLabel: UILabel = {
        
        var l: UILabel = UIFactory.createKindLabel()
        
        return l
    }()

    lazy var nameLabel: UILabel = {
        
        var l: UILabel = UIFactory.createNameLabel()
        
        if Device.IS_IPAD {
            l.font = UIFont.systemFont(ofSize: 30)
        }
        
        return l
    }()
    
    lazy var webView: WKWebView = {

        let wv:WKWebView = WKWebView(
            frame: self.view.bounds,
            configuration: WKWebViewConfiguration()
        )
        wv.translatesAutoresizingMaskIntoConstraints = false
        
        wv.scrollView.bounces = true
        wv.backgroundColor = UIColor.clear
        wv.scrollView.isScrollEnabled = true
        wv.isOpaque = false
        
        return wv
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(withItem: ITunesItem, fromSearchViewController: SearchViewController?) {
        
        super.init()
        
        self.searchViewController = fromSearchViewController
        
        self.title = NSLocalizedString("ItemDetailsTitle", comment: "")
        
        self.rightButton = UIBarButtonItem(image: UIImage(named: "bt-delete"), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = self.rightButton

        self.view.addSubview(self.kindLabel)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.webView)

        self.imageView.loadImageAsync(with: withItem.imageURL)
        self.nameLabel.text = withItem.name
        self.kindLabel.text = withItem.kind
        
        if (withItem.descriptionHTML?.count)! > 0 {
            wrapTextInsideHTML(withItem.descriptionHTML!)
        }
        else if (withItem.longDescription?.count)! > 0 {
            wrapTextInsideHTML(withItem.longDescription!)
        }
        
        self.updateViewConstraints()
    }
    
    private func wrapTextInsideHTML(_ text: String) {
        let textHTML: String = "<font face=\"Arial\" size=\"12\" color=\"#aaaaaa\">" + text + "</font>"
        
        self.webView.loadHTMLString(textHTML, baseURL: nil)
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()

        self.kindLabel.autoPinEdge(.left, to: .left, of: self.view)
        self.kindLabel.autoPinEdge(.right, to: .right, of: self.view)
        self.kindLabel.autoPinEdge(.top, to: .top, of: self.view)
        if Device.IS_IPHONE {
            self.kindLabel.autoSetDimension(.height, toSize: dr.r(v: 40))
        }
        else {
            self.kindLabel.autoSetDimension(.height, toSize: 40)
        }

        self.imageView.autoPinEdge(.left, to: .left, of: self.view, withOffset: dr.r(v: 15))
        self.imageView.autoPinEdge(.top, to: .bottom, of: self.kindLabel, withOffset: dr.r(v: 15))
        self.imageView.autoSetDimensions(to: CGSize(width: dr.r(v: 50), height: dr.r(v: 50)))
        
        self.nameLabel.autoPinEdge(.left, to: .right, of: self.imageView, withOffset: dr.r(v: 10))
        self.nameLabel.autoPinEdge(.right, to: .right, of: self.view, withOffset: dr.r(v: -5))
        self.nameLabel.autoPinEdge(.top, to: .top, of: self.imageView)
        self.nameLabel.autoPinEdge(.bottom, to: .bottom, of: self.imageView)

        self.webView.autoPinEdge(.left, to: .left, of: self.view, withOffset: dr.r(v: 10))
        self.webView.autoPinEdge(.right, to: .right, of: self.view, withOffset: dr.r(v: -10))
        self.webView.autoPinEdge(.top, to: .bottom, of: self.imageView, withOffset: dr.r(v: 10))
        self.webView.autoPinEdge(.bottom, to: .bottom, of: self.view)
    }
    
    @objc func rightButtonTapped() -> Void {
        
        let alertController = UIAlertController(title: NSLocalizedString("MessageTitle", comment: ""), message: NSLocalizedString("ConfirmDeleteItem", comment: ""), preferredStyle: .alert)
        
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
