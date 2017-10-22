//
//  FaceIdService.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import PromiseKit
import UserNotifications

class FaceIdService {
    
    private var lastSubmittedReqTime = Date()
    
    func handle(image: UIImage) {
        if Date().timeIntervalSince(lastSubmittedReqTime) < 1 {
            return
        }
        lastSubmittedReqTime = Date()
        firstly {
            return FaceIdHelper.getUserByFaceId(image: image)
        }.then { user -> Void in
            NotificationCenter.default.post(name: NotificationTable.userSignedIn, object: self, userInfo: user.toJSON())
        }.catch(policy: .allErrors) { error in
            log.info(error.localizedDescription)
        }
    }
    

}
