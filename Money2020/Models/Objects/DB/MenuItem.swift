//
//  MenuItems.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

struct Option {
    var title: String!
    var price: Double!
}

class MenuItem: Mappable {
    var menuItemId: String?
    var category: String?
    var title: String?
    var description: String?
    var imageUrl: String?
    var price: Double?
    var restaurantId: String?
    var carbs: Double?
    var protein: Double?
    var fat: Double?
    var calories: Double?
    var ingredients = [String]()
    var lastUpdated: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        menuItemId                  <- map[MenuItemDBSchema.menuItemId]
        category                    <- map[MenuItemDBSchema.category]
        title                       <- map[MenuItemDBSchema.title]
        description                 <- map[MenuItemDBSchema.description]
        imageUrl                    <- map[MenuItemDBSchema.imageUrl]
        price                       <- map[MenuItemDBSchema.price]
        restaurantId                <- map[MenuItemDBSchema.restaurantId]
        carbs                       <- map[MenuItemDBSchema.carbs]
        protein                     <- map[MenuItemDBSchema.protein]
        fat                         <- map[MenuItemDBSchema.fat]
        calories                    <- map[MenuItemDBSchema.calories]
        ingredients                 <- map[MenuItemDBSchema.ingredients]
        lastUpdated                 <- (map[MenuItemDBSchema.lastUpdated], DateTransform())
    }
    
    func getImage() -> Promise<UIImage> {
        return InstantUtils.getImage(withUrl: imageUrl!)
    }
    
    static func get(id: String) -> Promise<MenuItem> {
        return InstantAPIClient.getMenuItem(id: id)
    }

    
}
