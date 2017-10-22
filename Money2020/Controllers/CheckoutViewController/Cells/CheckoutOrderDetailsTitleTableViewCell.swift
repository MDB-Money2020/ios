//
//  CheckoutOrderDetailsTitleTableViewCell.swift
//  Money2020
//
//  Created by Sahil Lamba on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class CheckoutOrderDetailsTitleTableViewCell: UITableViewCell {
    
    var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        title = UILabel(frame: CGRect(x: 20, y: 20, width: frame.width - 20, height: frame.height - 20))
        title.textAlignment = .left
        title.font = UIFont(name: "SFUIText-Bold", size: 28)
        title.textColor = .black
        contentView.addSubview(title)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
