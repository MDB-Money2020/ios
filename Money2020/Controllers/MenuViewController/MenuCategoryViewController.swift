//
//  MenuCategoryViewController.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

protocol MenuCategoryViewControllerDelegate {
    func tappedMenuItem(item: MenuItem)
}
class MenuCategoryViewController: UIViewController {
    
    var menuItems = [MenuItem]()
    var collectionView: UICollectionView!
    var delegate: MenuCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    
}
