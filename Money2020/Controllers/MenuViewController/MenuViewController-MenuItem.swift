//
//  MenuItemCart.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Spring

extension MenuViewController {
    // MARK: Update UI Methods
    
    func updateUIWithCart() {
        if let order = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            if order.getNumMenuItems() > 0 {
                numLabel.text = String(order.getNumMenuItems())
                checkoutButton.isHidden = false
            } else {
                numLabel.text = "0"
                checkoutButton.isHidden = true
            }
        } else {
            numLabel.text = "0"
            checkoutButton.isHidden = true
        }
    }
    
    func updateUIAfterAddToCart() {
        let statusView = StatusView()
        statusView.alpha = 0
        statusView.show(inView: (navigationController?.view)!)
        
        SpringAnimation.springWithCompletion(duration: 0.5, animations: {
            if self.itemDetailView != nil {
                self.itemDetailView.frame = statusView.frame
            }
        }, completion: { _ in
            self.modalView.dismiss()
            statusView.alpha = 1
            statusView.displayMessage(text: "Added to Cart!")
            statusView.hideAfter(delay: 0.65, completion: nil)
            if self.checkoutButton.isHidden {
                self.checkoutButton.frame.origin.y = self.view.frame.height
                self.checkoutButton.isHidden = false
                SpringAnimation.springEaseIn(duration: 0.3, animations: {
                    self.checkoutButton.frame.origin.y = self.view.frame.height - self.checkoutButton.frame.height
                })
            }
            self.updateUIWithCart()
        })
    }
    
    func showItemDetailView(forItem: MenuItem) {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let mode: MenuItemDetailViewMode = .add
        itemDetailView = MenuItemDetailView(frame: CGRect(x: 200, y: 70, width: view.frame.width - 400, height: view.frame.height - 75 - (500 - navBarHeight! - statusBarHeight)), item: forItem, mode: mode)
        itemDetailView.delegate = self
        modalView = ModalView(view: itemDetailView)
        modalView.dismissAnimation = .FadeOut
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    
    func addToCart(item: MenuItem, quantity: Int, withOptions: [Option]) {
        var order: Order!
        if let currOrder = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            order = currOrder
        } else {
            order = Order(items: [], restaurantId: item.restaurantId!)
        }
        let orderItem = OrderItem(menuItemId: item.menuItemId!, menuItemName: item.title!, quantity: quantity, menuItemPrice: item.price!)
        order.addItem(item: orderItem)
        InstantLocalStore.saveCurrOrder(order: order)
    }
}

//MARK: MenuItemDetailView Delegate Methods

extension MenuViewController: MenuItemDetailViewDelegate {
    
    func dismissMenuItemDetailView() {
        modalView.dismiss()
    }
    
    func addItemToCart(item: MenuItem, quantity: Int) {
        addToCart(item: item, quantity: quantity, withOptions: [])
        updateUIAfterAddToCart()
    }
    
    func updateCart(item: MenuItem, newQuantity: Int) {
        //Do nothing
    }
}
