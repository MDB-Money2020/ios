//
//  FaceIdHelper.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseStorage

public enum ImageEmptyError: Error {
    case imageEmpty
}

extension ImageEmptyError: LocalizedError {
    public var errorDescription: String? {
        return "The image does not have any data."
    }
}
class FaceIdHelper {
    
    static func getUserByFaceId(image: UIImage) -> Promise<User> {
        return Promise<User> { fulfill, reject in
            firstly {
                return uploadImage(image: image)
            }.then { url -> Promise<User> in
                return InstantAPIClient.getUserByFaceId(imageUrl: url)
            }.then{ user -> Void in
                fulfill(user)
            }.catch(policy: .allErrors) { error in
                log.error(error.localizedDescription)
                reject(error)
            }
        }
    }
    
    private static func uploadImage(image: UIImage) -> Promise<String> {
        return Promise { fulfill, reject in
            let storageRef = Storage.storage().reference()
            let uuid = UUID().uuidString //Note: not consistent accross devices, fix this hack
            let imageRef = storageRef.child("faceImages/\(uuid).jpg")
            guard let data = UIImageJPEGRepresentation(image, 0.9) else {
                log.error("Image data is nil")
                reject(ImageEmptyError.imageEmpty)
                return
            }
            let _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    log.error(error!.localizedDescription)
                    reject(error!)
                } else {
                    if let url = metadata?.downloadURL()?.absoluteString {
                        print("uploaded image")
                        fulfill(url)
                    }
                    //TODO: should reject in else case
                }
            }
        }
    }
}
