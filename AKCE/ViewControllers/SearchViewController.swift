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

class SearchViewController: SuperViewController, SearchDelegateProtocol, UICollectionViewDelegate, ShowItemDelegateProtocol {

    private var rightButton: UIBarButtonItem?
    private var itemsArray: [ITunesItem] = []
    private var shouldDeleteCurrentItem: Bool = false
    
    private var currentMediaTypeSelected: MediaType = .All
    private var currentSearchQuery: String = ""
    
    private var api: APIClient = APIClient(baseURL: URL.init(string: "https://itunes.apple.com")!)
    private var currentTask: URLSessionDataTask?
    
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

    lazy var noResultsLabel: UILabel = {
        
        var l: UILabel = UIFactory.createNoResultsLabel()
        
        return l
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init() {
        super.init()
        
        self.title = NSLocalizedString("SearchTitle", comment: "")
        
        self.rightButton = UIBarButtonItem(image: UIImage(named: "bt-filter"), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = self.rightButton
        
        self.view.addSubview(self.noResultsLabel)
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
        
        self.noResultsLabel.autoCenterInSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        itemsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.shouldDeleteCurrentItem {
            self.itemsCollectionView.deleteCurrentItem()
            self.shouldDeleteCurrentItem = false
        }
    }
    
    @objc func rightButtonTapped() -> Void {
        
        let alertController = UIAlertController(title: NSLocalizedString("MessageTitle", comment: ""), message: NSLocalizedString("SelectMediaType", comment: ""), preferredStyle: (Device.IS_IPHONE ? .actionSheet : .alert))
        
        var action: UIAlertAction = UIAlertAction(title: NSLocalizedString("MediaType_All", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .All
            self.refilter()
        })
        action.setValue(self.currentMediaTypeSelected == .All ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
        
        action = UIAlertAction(title: NSLocalizedString("MediaType_Movie", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Movie
            self.refilter()
        })
        action.setValue(self.currentMediaTypeSelected == .Movie ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: NSLocalizedString("MediaType_Music", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Music
            self.refilter()
        })
        action.setValue(self.currentMediaTypeSelected == .Music ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: NSLocalizedString("MediaType_Podcast", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            self.currentMediaTypeSelected = .Podcast
            self.refilter()
        })
        action.setValue(self.currentMediaTypeSelected == .Podcast ? UIColor.blue : UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)

        action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
    public func refilter() -> () {

        if self.searchTextBox.getSearchText().count == 0 {
            
            self.itemsCollectionView.itemsArray?.removeAll()
            self.itemsCollectionView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self.noResultsLabel.alpha = 0
            })
            
            return
        }
        
        let searchTerm: String = self.searchTextBox.getSearchText().stringByAddingPercentEncodingForFormData(plusForSpace: true)!
        var mediaTypeForQuery: String!
        switch currentMediaTypeSelected {
        case .All:
            mediaTypeForQuery = "all"
            break
        case .Movie:
            mediaTypeForQuery = "movie"
            break
        case .Music:
            mediaTypeForQuery = "music"
            break
        case .Podcast:
            mediaTypeForQuery = "podcast"
            break
        }
        
        let queryString = "search?country=US&media=" + mediaTypeForQuery + "&term=" + searchTerm + "&limit=\(NUMBER_OF_ITEMS2RETRIEVE)"
        
        if queryString != self.currentSearchQuery {
            
            self.currentTask?.cancel()
            
            self.activityOn()
            
            self.currentTask = self.api.getItems(path: queryString, parameters: nil) { (code: NSInteger, result: Any?, message: String) in
                
                self.currentTask = nil
                
                DispatchQueue.main.async() {
                    if (code >= 0) {
                        self.itemsArray.removeAll()
                        if (result != nil) {
                            let resultAsDict = result as! [String : Any]
                            
                            for case let itemDict as [String : Any] in (resultAsDict["results"] as! [Any]) {
                                let itemObj = ITunesItem.init(itemDictionary: itemDict)
                                
                                if !PersistentStorage.shared().isURLDeleted(itemObj.viewURL!) {
                                    self.itemsArray.append(itemObj)
                                }
                            }
                        }
                        self.itemsCollectionView.itemsArray = self.itemsArray
                        self.itemsCollectionView.reloadData()
                        self.currentSearchQuery = queryString
                        self.activityOff()
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.noResultsLabel.alpha = (self.itemsArray.count > 0) ? 0 : 1
                            self.itemsCollectionView.alpha = (self.itemsArray.count > 0) ? 1 : 0
                        })                           
                    }
                    else {
                        self.activityOff()
                        let alertController = UIAlertController(title: NSLocalizedString("MessageTitle", comment: ""), message: NSLocalizedString("ERRMSG_CannotRetrieve", comment: ""), preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func showItem(_ item: ITunesItem) {
        self.navigationController?.pushViewController(ItemDetailsViewController(withItem: item, fromSearchViewController: self), animated: true)
    }
    
    public func deleteCurrentItem() {
        self.shouldDeleteCurrentItem = true
    }
}

