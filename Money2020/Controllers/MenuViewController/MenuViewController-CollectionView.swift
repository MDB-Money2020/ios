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

extension MenuViewController {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        collectionView = UICollectionView(frame: CGRect(x: 0, y: headerView.frame.maxY, width: view.frame.width, height: view.frame.height - headerView.frame.maxY), collectionViewLayout: layout)
        collectionView.register(MenuItemCollectionViewCell.self, forCellWithReuseIdentifier: "menuItemCell")
        collectionView.register(MenuHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "#F7F7F7")
        view.addSubview(collectionView)
    }
    
}

// MARK: CollectionView Delegate Methods

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategoryToMenuItem.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[section]]!.count
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
        let item = filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[indexPath.section]]?[indexPath.item]
        cell.nameLabel.text = item?.title!
        cell.priceLabel.text = InstantUtils.doubleToCurrencyString(val: (item?.price)!)
        
        firstly {
            return item!.getImage()
            }.then { img -> Void in
                cell.foodImageView.image = img
            }.catch(policy: .allErrors) { error in
                log.error(error.localizedDescription)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 90)/2, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MenuHeaderCollectionReusableView
            for subview in headerView.subviews {
                subview.removeFromSuperview()
            }
            headerView.awakeFromNib()
            headerView.titleLabel.text = Array(filteredCategoryToMenuItem.keys)[indexPath.section]
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[indexPath.section]]?[indexPath.item]
        showItemDetailView(forItem: item!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numSections = filteredCategoryToMenuItem.keys.count
        if section == numSections - 1 {
            return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        }
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}
