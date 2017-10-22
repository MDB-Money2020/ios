//
//  DateTransform.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import ObjectMapper

public class DateTransform: TransformType {
    
    public typealias Object = Date
    public typealias JSON = Int
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let unixTime = value as? Int {
            return Date(timeIntervalSince1970: TimeInterval(unixTime))
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970)
        }
        return nil
    }
    
}
