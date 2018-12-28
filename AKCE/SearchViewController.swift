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
    var itemsArray: [ITunesItem] = []
    
    lazy var searchTextBox:SearchTextField = {
        let stb: SearchTextField = SearchTextField.init(forAutoLayout: ())
        stb.searchDelegate = self
        return stb
    }()

    lazy var itemsCollectionView: ItemsCollectionView = {
        let cv: ItemsCollectionView = ItemsCollectionView.init(frame: self.view.bounds)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
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
        self.view.addSubview(self.itemsCollectionView)

        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.searchTextBox.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.view, withOffset: dr.r(v: 0))
        self.searchTextBox.autoPinEdge(ALEdge.right, to: ALEdge.right, of: self.view, withOffset: dr.r(v: 0))
        self.searchTextBox.autoPinEdge(ALEdge.top, to: ALEdge.top, of: self.view, withOffset: 2 + self.view.safeAreaInsets.top + self.additionalSafeAreaInsets.top)
        self.searchTextBox.autoSetDimension(ALDimension.height, toSize: CSEARCH_BAR_HEIGHT)
        
        self.itemsCollectionView.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.view, withOffset: dr.r(v: 0))
        self.itemsCollectionView.autoPinEdge(ALEdge.right, to: ALEdge.right, of: self.view, withOffset: dr.r(v: 0))
        self.itemsCollectionView.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: self.searchTextBox, withOffset: 0)
        self.itemsCollectionView.autoPinEdge(ALEdge.bottom, to: ALEdge.bottom, of: self.view, withOffset: dr.r(v: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api: APIClient = APIClient(baseURL: URL.init(string: "https://itunes.apple.com")!)
        
        api.getItems(path: "search?country=US&media=music&term=madonna&limit=100", parameters: nil) { (code: NSInteger, result: Any?, message: String) in
            
            DispatchQueue.main.async() {
                self.itemsArray.removeAll()
                
                if (result != nil) {
                    let resultAsDict = result as! [String : Any]
                    
                    for case let itemDict as [String : Any] in (resultAsDict["results"] as! [Any]) {
                        let itemObj = ITunesItem.init(itemDictionary: itemDict)
                        self.itemsArray.append(itemObj)
                    }
                }

//                self.table.reloadData()
            }
            
            print(result)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        itemsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightButtonTapped() -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("SelectMediaType", comment: ""), message: NSLocalizedString("SelectMediaType", comment: ""), preferredStyle: .actionSheet)
        
        var action: UIAlertAction = UIAlertAction(title: NSLocalizedString("SelectMediaType", comment: ""), style: .default, handler: { (action:UIAlertAction) in
        })
        action.setValue(UIColor.blue, forKey: "titleTextColor")
        alertController.addAction(action)
        
        action = UIAlertAction(title: "Take photo", style: .default, handler: { (action:UIAlertAction) in

        })
        action.setValue(UIColor.blue, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: "Choose from Library", style: .default, handler: { (action:UIAlertAction) in
        })
        action.setValue(UIColor.blue, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
    public func refilter(searchPhrase: String) -> () {
    }
}

