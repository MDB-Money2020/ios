//
//  CheckoutViewController-Cart.swift
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
    func updateCartWithQuantity(menuItem: MenuItem, newQuantity: Int) {
        var order: Order!
        if let currOrder = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            order = currOrder
        } else {
            order = Order(items: [], restaurantId: menuItem.restaurantId!)
        }
        order.updateQuantityForItem(orderItemId: (selectedItem?.orderItemId)!, newQuantity: newQuantity)
        InstantLocalStore.saveCurrOrder(order: order)
    }
    func updateUIAfterUpdateCart() {
        statusView.alpha = 0
        statusView.show(inView: (navigationController?.view)!)
        
        SpringAnimation.springWithCompletion(duration: 0.5, animations: {
            self.itemDetailView.frame = self.statusView.frame
        }, completion: { _ in
            self.modalView.dismiss()
            self.statusView.alpha = 1
            self.statusView.displayMessage(text: "Cart Updated!")
            self.statusView.hideAfter(delay: 1.0, completion: nil)
        })
    }
}
