//
//  CheckoutCommentsTableViewCell.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class CheckoutCommentsTableViewCell: UITableViewCell {

    var commentsTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        commentsTextField = UITextField(frame: CGRect(x: 20, y: 20, width: frame.width - 40, height: frame.height - 20))
        commentsTextField.backgroundColor = UIColor(hex: "#FBFBFB")
        commentsTextField.borderStyle = .none
        commentsTextField.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
        commentsTextField.layer.borderWidth = 1
        commentsTextField.font = UIFont(name: "SFUIText-Regular", size: 20)
        commentsTextField.placeholder = "Additional instructions..."
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: commentsTextField.frame.height))
        commentsTextField.leftView = paddingView
        commentsTextField.leftViewMode = UITextFieldViewMode.always
        contentView.addSubview(commentsTextField)
    }

}
