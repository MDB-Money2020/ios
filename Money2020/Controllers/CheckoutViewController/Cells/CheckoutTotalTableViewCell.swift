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
        
        infoLabel = UILabel(frame: CGRect(x: 60, y: 20, width: frame.width - 200 - 60, height: 40))
        infoLabel.textColor = UIColor(hex: "#212A31")
        infoLabel.font = UIFont(name: "SFUIText-Regular", size: 24)
        contentView.addSubview(infoLabel)
        
        valueLabel = UILabel(frame: CGRect(x: frame.width - 200, y: 20, width: 160, height: 40))
        valueLabel.textColor = UIColor(hex: "#212A31")
        valueLabel.font = UIFont(name: "SFUIText-Medium", size: 24)
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
    }
    
}

