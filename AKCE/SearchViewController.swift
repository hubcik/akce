//
//  ViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 27/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegateProtocol {

    var rightButton: UIBarButtonItem? = nil
    
    lazy var searchTextBox:SearchTextField = {
        let stb:SearchTextField = SearchTextField.init(forAutoLayout: ())
        stb.searchDelegate = self
        return stb
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = COLOR_VIEWCONTROLLER_BACKGROUND
        
        self.title = NSLocalizedString("SearchTitle", comment: "")
        
        self.rightButton = UIBarButtonItem(image: UIImage(named: "bt-mediaType"), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = self.rightButton
        
        self.view.addSubview(self.searchTextBox)

        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.searchTextBox.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.view, withOffset: dr.r(v: 0))
        self.searchTextBox.autoPinEdge(ALEdge.right, to: ALEdge.right, of: self.view, withOffset: dr.r(v: 0))
        self.searchTextBox.autoPinEdge(ALEdge.top, to: ALEdge.top, of: self.view, withOffset: self.view.safeAreaInsets.top + self.additionalSafeAreaInsets.top)
        self.searchTextBox.autoSetDimension(ALDimension.height, toSize: CSEARCH_BAR_HEIGHT)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func rightButtonTapped() -> Void {
    }
    
    public func refilter(searchPhrase: String) -> () {
    }
}

