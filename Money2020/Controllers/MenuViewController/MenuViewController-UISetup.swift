//
//  MenuItemUI.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PageMenu

extension MenuViewController {
    // MARK: UI Setup Methods
    
    func setupNavbar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.title = "Menu"
        navigationController?.navigationBar.tintColor = UIColor(hex: "#494949")
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "SFUIText-Regular", size: 17)!]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupFaceRecView() {
        faceRecView = FaceRecView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3))
        faceRecView.delegate = self
        view.addSubview(faceRecView)
    }
    
    func setupCheckoutButton() {
        checkoutButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 80))
        checkoutButton.backgroundColor = UIColor(hex: "#6ECC3D")
        checkoutButton.setTitle("CHECKOUT", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 23)
        checkoutButton.isHidden = true
        numLabel = UILabel(frame: CGRect(x: 90, y: (checkoutButton.frame.height - 25)/2, width: 25, height: 25))
        numLabel.font = UIFont(name: "SFUIText-Medium", size: 14)
        numLabel.textAlignment = .center
        numLabel.textColor = .white
        numLabel.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        numLabel.layer.cornerRadius = numLabel.frame.width/2
        numLabel.clipsToBounds = true
        checkoutButton.addSubview(numLabel)
        checkoutButton.addTarget(self, action: #selector(toCheckout), for: .touchUpInside)
        view.addSubview(checkoutButton)
        
        updateUIWithCart()
    }
    
    func setupPageMenu() {
        let menuFont = UIFont(name: "SFUIText-Semibold", size: 23)!
        let options: [CAPSPageMenuOption] = [.selectionIndicatorColor(.red),
                                             .menuHeight(75),
                                             .menuItemFont(menuFont),
                                             .centerMenuItems(true),
                                             .selectionIndicatorHeight(5),
                                             .menuMargin(75),
                                             .menuItemWidthBasedOnTitleTextWidth(true)]
        for category in categories {
            let controller = MenuCategoryViewController()
            controller.title = category
            controller.delegate = self
            controllerArray.append(controller)
        }
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: headerView.frame.maxY, width: view.frame.width, height: view.frame.height - headerView.frame.maxY), pageMenuOptions: options)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    //TODO: put suggestions first
    func updateCategoryVCs(categoryToMenuItems: [String: [MenuItem]]) {
        for controller in controllerArray {
            if controller.title != nil && categoryToMenuItems[controller.title!] != nil {
                controller.menuItems = categoryToMenuItems[controller.title!]!
                if controller.collectionView != nil {
                   controller.collectionView.reloadData()
                }
            }
        }
    }
    

}

extension MenuViewController: MenuCategoryViewControllerDelegate {
    func tappedMenuItem(item: MenuItem) {
        showItemDetailView(forItem: item)
    }
}
