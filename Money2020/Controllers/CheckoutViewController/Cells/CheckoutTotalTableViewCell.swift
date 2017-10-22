//
//  CheckoutTotalTableViewCell.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit


class CheckoutTotalTableViewCell: UITableViewCell {
    
    var infoLabel: UILabel!
    var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        infoLabel = UILabel(frame: CGRect(x: 60, y: 20, width: frame.width - 90 - 60, height: 25))
        infoLabel.textColor = UIColor(hex: "#212A31")
        infoLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        contentView.addSubview(infoLabel)
        
        valueLabel = UILabel(frame: CGRect(x: frame.width - 90, y: 20, width: 80, height: 25))
        valueLabel.textColor = UIColor(hex: "#212A31")
        valueLabel.font = UIFont(name: "SFUIText-Medium", size: 14)
        contentView.addSubview(valueLabel)
        
    }
    
}

