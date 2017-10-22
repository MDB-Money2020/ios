//
//  InstantLocalStore.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper

class InstantLocalStore {
    
    static func setCurrUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "currUserId")
    }
    
    static func getCurrUserId() -> String? {
        if let userId = UserDefaults.standard.string(forKey: "currUserId") {
            return userId
        }
        return nil
    }
    
    static func saveCurrOrder(order: Order) {
        let json = order.toJSON()
        UserDefaults.standard.set(json, forKey: "\(order.restaurantId!)/currOrder")
    }
    
    static func getCurrOrder(atRestaurantId: String) -> Order? {
        if let json = UserDefaults.standard.dictionary(forKey: "\(atRestaurantId)/currOrder") {
            return Order(JSON: json)
        }
        return nil
    }
    
    static func clearCurrOrder(atRestaurantId: String) {
        UserDefaults.standard.removeObject(forKey: "\(atRestaurantId)/currOrder")
    }
}
