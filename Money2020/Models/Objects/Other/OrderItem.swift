//
//  OrderItem.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderItem: Mappable {
    
    var orderItemId: String?
    var menuItemId: String?
    var quantity: Int?
    var menuItemPrice: Double?
    var menuItemName: String?
    
    required init?(map: Map) {
        
    }
    
    init(menuItemId: String, menuItemName: String, quantity: Int, menuItemPrice: Double) {
        self.menuItemId = menuItemId
        self.quantity = quantity
        self.menuItemPrice = menuItemPrice
        self.menuItemName = menuItemName
        self.orderItemId = menuItemId
    }
    
    func mapping(map: Map) {
        orderItemId             <- map[OrderItemDBSchema.orderItemId]
        menuItemId              <- map[OrderItemDBSchema.menuItemId]
        quantity                <- map[OrderItemDBSchema.quantity]
        menuItemPrice           <- map[OrderItemDBSchema.menuItemPrice]
        menuItemName            <- map[OrderItemDBSchema.menuItemName]
    }
    
    func getTotalPrice() -> Double {
        return menuItemPrice! * Double(quantity!)
    }
    
}
