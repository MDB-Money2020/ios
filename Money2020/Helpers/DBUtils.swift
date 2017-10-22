//
//  InstantUtils.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import PromiseKit
import Haneke

class InstantUtils {
    static func getImage(withUrl: String) -> Promise<UIImage> {
        return Promise { fulfill, _ in
            let cache = Shared.imageCache
            if let imageUrl = URL(string: withUrl) {
                cache.fetch(URL: imageUrl).onSuccess({ img in
                    fulfill(img)
                })
            }
        }
    }
    
    static func doubleToCurrencyString(val: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        return formatter.string(from: NSNumber(value: val))!
    }
}
