//
//  ItemsCollectionView.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

protocol ShowItemDelegateProtocol: class {
    func showItem(_ item: ITunesItem)
}

class ItemsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public var itemsArray: [ITunesItem]! = []
    public weak var showItemDelegate: ShowItemDelegateProtocol?
    private var currentIndexPath: IndexPath! = IndexPath(item: -1, section: -1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(frame: CGRect) {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.zero
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .vertical
        
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)

        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier())

        self.dataSource = self
        self.delegate = self
    
        self.bounces = true
    
        self.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell = self.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier(), for: indexPath) as! ItemCollectionViewCell

        cell.setItem(self.itemsArray![indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.currentIndexPath = indexPath
        let selectedItem = self.itemsArray![indexPath.row]

        if !selectedItem.isVisited {
            selectedItem.markVisited()
            self.reloadData()
        }
        
        self.showItemDelegate?.showItem(selectedItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: Flat should not change the size
        if Device.IS_IPHONE && UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
            //Portrait
            return CGSize(width: UIScreen.main.bounds.size.width, height: 100)
        }
        else {
            //Landscape
            return CGSize(width: (UIScreen.main.bounds.size.width - 2) / 2, height: 100)
        }
    }
    
    public func deleteCurrentItem() {
        if self.currentIndexPath.section >= 0 {
            
            itemsArray[self.currentIndexPath.row].markDeleted()
            
            self.itemsArray?.remove(at: self.currentIndexPath.row)
            self.deleteItems(at: [self.currentIndexPath!])
            
            currentIndexPath.section = -1
        }
    }
}
