//
//  Restaurant.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

class Restaurant: Mappable {
    var restaurantId: String?
    var name: String?
    var logoUrl: String?
    var imageUrl: String?
    var menuItemIds: String?
    var lastUpdated: Date?
    var visaAccountId: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name                        <- map[RestaurantDBSchema.name]
        restaurantId                <- map[RestaurantDBSchema.restaurantId]
        logoUrl                     <- map[RestaurantDBSchema.logoUrl]
        imageUrl                    <- map[RestaurantDBSchema.imageUrl]
        menuItemIds                 <- map[RestaurantDBSchema.menuItemIds]
        visaAccountId               <- map[RestaurantDBSchema.visaAccountId]
        lastUpdated                 <- (map[UserDBSchema.lastUpdated], DateTransform())
    }
    
    static func getMenuItems(restaurantId: String) -> Promise<[MenuItem]> {
        return InstantAPIClient.getMenuItems(restaurantId: restaurantId)
    }
    
    static func getMenuSuggestions(userId: String, restaurantId: String) -> Promise<[MenuItem]> {
        return InstantAPIClient.getMenuSuggestions(userId: userId, restaurantId: restaurantId)
    }
    
    static func get(withId: String) -> Promise<Restaurant> {
        return InstantAPIClient.getRestaurant(id: withId)
    }
    
    func getBackgroundImage() -> Promise<UIImage> {
        return InstantUtils.getImage(withUrl: imageUrl!)
    }
   
}
