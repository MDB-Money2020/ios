//
//  OrderDBSchema.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation

struct OrderDBSchema {
    static let orderId = "_key"
    static let orderItems = "orderItems"
    static let chargeId = "chargeId"
    static let menuItemId = "menuItemId"
    static let userId = "userId"
    static let restaurantId = "restaurantId"
    static let quantity = "quantity"
    static let total = "total"
    static let lastUpdated = "lastUpdated"
    static let timePlaced = "timePlaced"
    static let timeCompleted = "timeCompleted"
    static let status = "status"
    static let additionalInstructions = "additionalInstructions"
}
