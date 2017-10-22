//
//  CheckoutItemTableViewCell.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

struct CheckoutItemTableViewCellSettings {
    static var leftMargin: CGFloat = 15
    static var rightMargin: CGFloat = 15
    static var contentLabelFont = UIFont(name: "SFUIText-Regular", size: 14)
}

class CheckoutItemTableViewCell: UITableViewCell {
    
    var quantityLabel: UILabel!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        selectionStyle = .none
        
        quantityLabel = UILabel(frame: CGRect(x: 15, y: 20, width: 25, height: 25))
        quantityLabel.backgroundColor = UIColor(hex: "#6ECC3D")
        quantityLabel.textColor = .white
        quantityLabel.font = UIFont(name: "SFUIText-Medium", size: 14)
        quantityLabel.textAlignment = .center
        quantityLabel.layer.cornerRadius = 2
        quantityLabel.clipsToBounds = true
        contentView.addSubview(quantityLabel)
        
        nameLabel = UILabel(frame: CGRect(x: quantityLabel.frame.maxX + 20, y: quantityLabel.frame.minY, width: frame.width - 90 - quantityLabel.frame.maxX - 20, height: 25))
        nameLabel.textColor = UIColor(hex: "#212A31")
        nameLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        contentView.addSubview(nameLabel)
        
        priceLabel = UILabel(frame: CGRect(x: frame.width - 90, y: quantityLabel.frame.minY, width: 80, height: 25))
        priceLabel.textColor = UIColor(hex: "#212A31")
        priceLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        contentView.addSubview(priceLabel)
    }
    
    
}

