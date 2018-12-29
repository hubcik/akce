//
//  ViewController.swift
//  AKCE
//
//  Created by Hubert Gostomski on 27/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

enum MediaType {
    case All
    case Movie
    case Music
    case Podcast
}

class SearchViewController: UIViewController, SearchDelegateProtocol, UICollectionViewDelegate, ShowItemDelegateProtocol {

    private var rightButton: UIBarButtonItem?
    private var itemsArray: [ITunesItem] = []
    private var shouldDeleteCurrentItem: Bool = false
    
    private var currentMediaTypeSelected: MediaType = .All
    
    lazy var searchTextBox:SearchTextField = {
        let stb: SearchTextField = SearchTextField.init(forAutoLayout: ())
        stb.searchDelegate = self
        return stb
    }()

    lazy var itemsCollectionView: ItemsCollectionView = {
        let collectionView: ItemsCollectionView = ItemsCollectionView.init(frame: self.view.bounds)
        
        collectionView.showItemDelegate = self
        
        return collectionView
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = COLOR_VIEWCONTROLLER_BACKGROUND
        
        self.title = NSLocalizedString("SearchTitle", comment: "")
        
        self.rightButton = UIBarButtonItem(image: UIImage(named: "bt-filter"), style: .plain, target: self, action: #selector(rightButtonTapped))
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
        navigationController?.navigationBar.backItem?.title = "Back"

        self.refilter(searchPhrase: "")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        itemsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.shouldDeleteCurrentItem {
            self.itemsCollectionView.deleteCurrentItem()
            self.shouldDeleteCurrentItem = false;
        }
    }
    
    @objc func rightButtonTapped() -> Void {
        
        let alertController = UIAlertController(title: NSLocalizedString("MessageTitle", comment: ""), message: NSLocalizedString("SelectMediaType", comment: ""), preferredStyle: .actionSheet)
        
        var action: UIAlertAction = UIAlertAction(title: NSLocalizedString("MediaType_All", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .All
        })
        action.setValue(self.currentMediaTypeSelected == .All ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
        
        action = UIAlertAction(title: NSLocalizedString("MediaType_Movie", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Movie
        })
        action.setValue(self.currentMediaTypeSelected == .Movie ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: NSLocalizedString("MediaType_Music", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Music
        })
        action.setValue(self.currentMediaTypeSelected == .Music ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: NSLocalizedString("MediaType_Podcast", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Podcast
        })
        action.setValue(self.currentMediaTypeSelected == .Podcast ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
    public func refilter(searchPhrase: String) -> () {
        let api: APIClient = APIClient(baseURL: URL.init(string: "https://itunes.apple.com")!)
        
        api.getItems(path: "search?country=US&media=all&term=hanks&limit=100", parameters: nil) { (code: NSInteger, result: Any?, message: String) in
            
            DispatchQueue.main.async() {
                self.itemsArray.removeAll()
                
                if (result != nil) {
                    let resultAsDict = result as! [String : Any]
                    
                    for case let itemDict as [String : Any] in (resultAsDict["results"] as! [Any]) {
                        let itemObj = ITunesItem.init(itemDictionary: itemDict)
                        self.itemsArray.append(itemObj)
                    }
                }
                
                self.itemsCollectionView.itemsArray = self.itemsArray
                self.itemsCollectionView.reloadData()
            }
            
            print(result)
        }
    }
    
    @objc func showItem(_ item: ITunesItem) {
        self.navigationController?.pushViewController(ItemDetailsViewController(withItem: item, fromSearchViewController: self), animated: true)
    }
    
    public func deleteCurrentItem() {
        self.shouldDeleteCurrentItem = true
    }
}

