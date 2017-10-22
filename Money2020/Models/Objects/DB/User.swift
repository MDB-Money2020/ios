//
//  User.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

class User: Mappable {
    var userId: String?
    var orderIds = [String]()
    var fullName: String?
    var paymentSources = [String]()
    var imageUrls = [String]()
    var lastUpdated: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId                <- map[UserDBSchema.userId]
        orderIds              <- map[UserDBSchema.orderIds]
        fullName              <- map[UserDBSchema.fullName]
        paymentSources        <- map[UserDBSchema.paymentSources]
        imageUrls             <- map[UserDBSchema.imageUrls]
        lastUpdated           <- (map[UserDBSchema.lastUpdated], DateTransform())
    }

}
