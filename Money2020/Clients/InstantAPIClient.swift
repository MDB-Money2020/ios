//
//  InstantAPIClient.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON


public enum ResourceNotFoundError: Error {
    case resourceNotFound
}

extension ResourceNotFoundError: LocalizedError {
    public var errorDescription: String? {
        return "The requested resource was not found in the database."
    }
}

public enum RequestTimedOutError: Error {
    case requestTimedOut
}

extension RequestTimedOutError: LocalizedError {
    public var errorDescription: String? {
        return "The network request timed out."
    }
}

class InstantAPIClient {
    
    static func getUserByFaceId(imageUrl: String) -> Promise<User> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "users/verification/"
            let params: [String: Any] = ["imageUrl": imageUrl]
            Alamofire.request(endpoint, method: .patch, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let result = json["result"].dictionaryObject {
                    if let user = User(JSON: result) {
                        fulfill(user)
                    }
                }
            }.catch { error in
                log.error(error.localizedDescription)
                reject(error)
            }
        }
    }

    
    static func getUser(id: String) -> Promise<User> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "users?userId=\(id)"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let result = json["result"].dictionaryObject {
                    if let user = User(JSON: result) {
                        fulfill(user)
                    }
                }
            }.catch { error in
                log.error(error.localizedDescription)
                reject(error)
            }
        }
    }
    
    static func getRestaurant(id: String) -> Promise<Restaurant> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "restaurants/\(id)"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let result = json["result"].dictionaryObject {
                    if let restaurant = Restaurant(JSON: result) {
                        fulfill(restaurant)
                    }
                }
                }.catch { error in
                    log.error(error.localizedDescription)
                    reject(error)
            }
        }
    }
    
    static func getMenuItem(id: String) -> Promise<MenuItem> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "menuItems/\(id)"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let result = json["result"].dictionaryObject {
                    if let menuItem = MenuItem(JSON: result) {
                        fulfill(menuItem)
                    }
                }
            }.catch { error in
                log.error(error.localizedDescription)
                reject(error)
            }
        }
    }
    
    //TODO: fix route
    static func getSuggestedMenuItems(restaurantId: String) -> Promise<[MenuItem]> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "menuItems?restaurantId=\(restaurantId)"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let results = json["result"].array {
                    var items = [MenuItem]()
                    for result in results {
                        if let item = MenuItem(JSON: result.dictionaryObject!) {
                            items.append(item)
                        }
                    }
                    fulfill(items)
                }
            }.catch { error in
                log.error(error.localizedDescription)
                reject(error)
            }
        }
    }
    
    static func getMenuItems(restaurantId: String) -> Promise<[MenuItem]> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "menuItems?restaurantId=\(restaurantId)"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let results = json["result"].array {
                    var items = [MenuItem]()
                    for result in results {
                        if let item = MenuItem(JSON: result.dictionaryObject!) {
                            items.append(item)
                        }
                    }
                    fulfill(items)
                }
                }.catch { error in
                    log.error(error.localizedDescription)
                    reject(error)
            }
        }
    }
    
    static func getMenuSuggestions(userId: String, restaurantId: String) -> Promise<[MenuItem]> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "menuItems?userId=\(userId)&restaurantId=\(restaurantId)&suggested=true"
            Alamofire.request(endpoint).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let results = json["result"].array {
                    var items = [MenuItem]()
                    for result in results {
                        if let item = MenuItem(JSON: result.dictionaryObject!) {
                            items.append(item)
                        }
                    }
                    fulfill(items)
                }
                }.catch { error in
                    log.error(error.localizedDescription)
                    reject(error)
            }
        }
    }
    
    static func placeOrder(userId: String, restaurantId: String, instructions: String, orderItems: [String: Any]) -> Promise<Order> {
        return Promise { fulfill, reject in
            after(interval: 10).then { _ -> Void in
                reject(RequestTimedOutError.requestTimedOut)
            }
            let endpoint = Constants.apiUrl + "orders"
            let params: [String: Any] = ["userId": userId,
                                         "restaurantId": restaurantId,
                                         "instructions": instructions,
                                         "orderItems": orderItems]
            Alamofire.request(endpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON().then { response -> Void in
                let json = JSON(object: response)
                log.info("Response: \(json.description)")
                if let result = json["result"].dictionaryObject {
                    if let order = Order(JSON: result) {
                        fulfill(order)
                    }
                }
                }.catch { error in
                    log.error(error.localizedDescription)
                    reject(error)
            }
        }
    }

}
