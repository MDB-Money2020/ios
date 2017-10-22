//
//  Order.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//


import Foundation
import ObjectMapper
import PromiseKit

class Order: Mappable {
    
    var orderId: String?
    var chargeId: String?
    var orderItems = [String: Any]()
    var userId: String?
    var restaurantId: String?
    var quantity: Int?
    var total: Double?
    var lastUpdated: Date?
    var timePlaced: Date?
    var timeCompleted: Date?
    var status: String?
    var additionalInstructions = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        orderId                             <- map[OrderDBSchema.orderId]
        additionalInstructions              <- map[OrderDBSchema.additionalInstructions]
        chargeId                            <- map[OrderDBSchema.chargeId]
        orderItems                          <- map[OrderDBSchema.orderItems]
        userId                              <- map[OrderDBSchema.userId]
        restaurantId                        <- map[OrderDBSchema.restaurantId]
        quantity                            <- map[OrderDBSchema.quantity]
        total                               <- map[OrderDBSchema.total]
        timePlaced                          <- map[OrderDBSchema.timePlaced]
        timeCompleted                       <- map[OrderDBSchema.timeCompleted]
        status                              <- map[OrderDBSchema.status]
        lastUpdated                         <- (map[UserDBSchema.lastUpdated], DateTransform())
    }
    
    init(items: [OrderItem], restaurantId: String) {
        self.restaurantId = restaurantId
        for item in items {
            addItem(item: item)
        }
    }
    
    func getNumOrderItems() -> Int {
        return orderItems.keys.count
    }
    
    func getNumMenuItems() -> Int {
        let orderItems = getOrderItems()
        var total = 0
        for item in orderItems {
            total += item.quantity!
        }
        return total
    }
    
    func getTotal() -> Double {
        var total = 0.0
        for (key, val) in orderItems {
            if var itemDict = val as? [String: Any] {
                itemDict["_key"] = key
                if let item = OrderItem(JSON: itemDict) {
                    if let quantity = item.quantity {
                        total += (Double(quantity) * item.getTotalPrice())
                    }
                }
                
            }
        }
        return total
    }
    
    func getOrderItems() -> [OrderItem] {
        var items = [OrderItem]()
        for (key, val) in orderItems {
            if var itemDict = val as? [String: Any] {
                itemDict["_key"] = key
                if let item = OrderItem(JSON: itemDict) {
                    items.append(item)
                }
                
            }
        }
        return items
    }
    
    func addItem(item: OrderItem) {
        if orderItems[item.orderItemId!] != nil {
            if var json = orderItems[item.orderItemId!] as? [String: Any] {
                json["_key"] = item.orderItemId!
                if let orderItem = OrderItem(JSON: json) {
                    orderItem.quantity! += item.quantity!
                    let newJson = orderItem.toJSON()
                    orderItems[item.orderItemId!] = newJson
                }
            }
        } else {
            let json = item.toJSON()
            orderItems[item.orderItemId!] = json
        }
    }

    func removeItem(withId: String) {
        if orderItems[withId] != nil {
            orderItems.removeValue(forKey: withId)
        }
    }
    
    func updateQuantityForItem(orderItemId: String, newQuantity: Int) {
        if orderItems[orderItemId] != nil {
            if var json = orderItems[orderItemId] as? [String: Any] {
                json["_key"] = orderItemId
                if let orderItem = OrderItem(JSON: json) {
                    orderItem.quantity = newQuantity
                    let newJson = orderItem.toJSON()
                    orderItems[orderItemId] = newJson
                }
                
            }
        }
    }
    
}
