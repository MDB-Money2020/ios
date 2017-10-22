//
//  MenuHeaderCollectionReusableView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class MenuHeaderCollectionReusableView: UICollectionReusableView {

    var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: (frame.height - 20)/2, width: frame.width - 20, height: 20))
        titleLabel.font = UIFont(name: "SFUIText-Regular", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: "#212A31")
        addSubview(titleLabel)
    }

}
