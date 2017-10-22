//
//  MenuItemCollectionViewCell.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var foodImageView: UIImageView!
    var overlayView: UIImageView!
    
    override func awakeFromNib() {
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.85
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        foodImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        contentView.addSubview(foodImageView)
        
        overlayView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        overlayView.contentMode = .scaleAspectFill
        overlayView.image = UIImage(named: "overlay")
        overlayView.clipsToBounds = true
        contentView.addSubview(overlayView)
        
        nameLabel = UILabel(frame: CGRect(x: 30, y: foodImageView.frame.maxY - 110, width: frame.width - 60, height: 60))
        nameLabel.font = UIFont(name: "SFUIText-Bold", size: 28)
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 30, y: nameLabel.frame.maxY, width: frame.width - 60, height: 18))
        priceLabel.font = UIFont(name: "SFUIText-Semibold", size: 25)
        priceLabel.textColor = UIColor(hex: "#53CFAA")
        contentView.addSubview(priceLabel)
        
        
    }
}
