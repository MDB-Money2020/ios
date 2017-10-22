//
//  HelloView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class HelloView: UIView {
    
    var overlay: UIView!
    var textLabel: UILabel!
    var imageView: UIImageView!
    var restaurantName: String!

    init(frame: CGRect, restaurantName: String) {
        super.init(frame: frame)
        self.restaurantName = restaurantName
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        overlay.backgroundColor = .black
        overlay.alpha = 0.5
        addSubview(overlay)
        
        imageView = UIImageView(frame: CGRect(x: (overlay.frame.width - 200)/2, y: (overlay.frame.height - 150)/2 - 50, width: 200, height: 200))
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: 100, y: imageView.frame.maxY + 5, width: overlay.frame.width - 200, height: 150))
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = UIFont(name: "SFUIText-Regular", size: 30)
        textLabel.text = "Detecting face..."
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(fullName: String, image: UIImage) {
        textLabel.text = "Hi, \(fullName)! \n Welcome to \(restaurantName!)"
        imageView.image = image
    }
    
}
