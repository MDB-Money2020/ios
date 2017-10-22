//
//  MenuItemCollectionView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

extension MenuCategoryViewController {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(MenuItemCollectionViewCell.self, forCellWithReuseIdentifier: "menuItemCell")
        collectionView.register(MenuHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "#F7F7F7")
        view.addSubview(collectionView)
    }
    
}

// MARK: CollectionView Delegate Methods

extension MenuCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! MenuItemCollectionViewCell
        let item = menuItems[indexPath.item]
        cell.nameLabel.text = item.title!
        cell.priceLabel.text = InstantUtils.doubleToCurrencyString(val: item.price!)
        
        firstly {
            return item.getImage()
            }.then { img -> Void in
                cell.foodImageView.image = img
            }.catch(policy: .allErrors) { error in
                log.error(error.localizedDescription)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 90)/2, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = menuItems[indexPath.item]
        delegate?.tappedMenuItem(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
}
