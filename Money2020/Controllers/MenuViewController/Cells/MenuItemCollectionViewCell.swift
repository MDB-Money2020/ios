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
    var descriptionLabel: UILabel!
    var priceLabel: UILabel!
    var foodImageView: UIImageView!
    var separator: UIView!
    
    override func awakeFromNib() {
        
        foodImageView = UIImageView(frame: CGRect(x: frame.width - 130, y: 10, width: 110, height: 85))
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        contentView.addSubview(foodImageView)
        
        nameLabel = UILabel(frame: CGRect(x: 15, y: 10, width: frame.width - foodImageView.frame.minX - 15, height: 18))
        nameLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        nameLabel.textColor = UIColor(hex: "#212A31")
        contentView.addSubview(nameLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: 15, y: nameLabel.frame.maxY + 5, width: frame.width - 140 - 15, height: 40))
        descriptionLabel.font = UIFont(name: "SFUIText-Light", size: 13)
        descriptionLabel.textColor = UIColor(hex: "#4F606E")
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(descriptionLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 15, y: descriptionLabel.frame.maxY + 5, width: frame.width - 140 - 15, height: 18))
        priceLabel.font = UIFont(name: "SFUIText-Light", size: 13)
        priceLabel.textColor = UIColor(hex: "#4F606E")
        contentView.addSubview(priceLabel)
        
        separator = UIView(frame: CGRect(x: 10, y: frame.height - 1, width: frame.width - 20, height: 0.8))
        separator.backgroundColor = UIColor(hex: "#EEEFF0")
        separator.layer.cornerRadius = 0.4
        separator.clipsToBounds = true
        contentView.addSubview(separator)
        
    }
}
