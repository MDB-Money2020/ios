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
    
    private var isAvailable = true
    private var semaphore = DispatchSemaphore(value: 1)
    
//    func handle(image: UIImage) {
//        if !isAvailable {
//            return
//        }
//        if semaphore.wait(timeout: .now() + 5) == .timedOut {
//            isAvailable = true
//            return
//        }
//        isAvailable = false
//
//        firstly {
//            return FaceIdHelper.getUserByFaceId(image: image)
//        }.then { user -> Void in
//            NotificationCenter.default.post(name: NotificationTable.userSignedIn, object: self, userInfo: user.toJSON())
//        }.catch(policy: .allErrors) { error in
//            log.info(error.localizedDescription)
//        }.always {
//            self.isAvailable = true
//            self.semaphore.signal()
//        }
//    }
    func handle(image: UIImage) {

        firstly {
            return FaceIdHelper.getUserByFaceId(image: image)
            }.then { user -> Void in
                NotificationCenter.default.post(name: NotificationTable.userSignedIn, object: self, userInfo: user.toJSON())
            }.catch(policy: .allErrors) { error in
                log.info(error.localizedDescription)
            }.always {

        }
    }
}
