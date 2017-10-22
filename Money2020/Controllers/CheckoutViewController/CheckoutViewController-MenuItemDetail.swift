//
//  CheckoutViewController-MenuItemDetail.swift
//  Money2020
//
//  Created by Sahil Lamba on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Spring

extension CheckoutViewController {
    func showItemDetailView(forItem: MenuItem) {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var mode: MenuItemDetailViewMode = .add
        itemDetailView = MenuItemDetailView(frame: CGRect(x: 200, y: 70, width: view.frame.width - 400, height: view.frame.height - 75 - (500 - navBarHeight! - statusBarHeight)), item: forItem, mode: mode)
        itemDetailView.delegate = self
        itemDetailView.setQuantity(quantity: (selectedItem?.quantity)!)
        modalView = ModalView(view: itemDetailView)
        modalView.dismissAnimation = .FadeOut
        modalView.dismissCompletion = {
            self.refresh()
        }
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
}

extension CheckoutViewController: MenuItemDetailViewDelegate {
    func dismissMenuItemDetailView() {
        modalView.dismiss()
    }
    
    func addItemToCart(item: MenuItem, quantity: Int) {
        //Do nothing
    }
    
    func updateCart(item: MenuItem, newQuantity: Int) {
        updateCartWithQuantity(menuItem: item, newQuantity: newQuantity)
        updateUIAfterUpdateCart()
        modalView.dismiss()
    }
    
    
}
