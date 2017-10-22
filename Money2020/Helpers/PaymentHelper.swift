//
//  PaymentHelper.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import PromiseKit

class PaymentHelper {
    static func placeOrder(order: Order) -> Promise<Order> {
        return InstantAPIClient.placeOrder(userId: InstantLocalStore.getCurrUserId()!, restaurantId: order.restaurantId!, instructions: order.additionalInstructions, orderItems: order.orderItems)
    }
}
