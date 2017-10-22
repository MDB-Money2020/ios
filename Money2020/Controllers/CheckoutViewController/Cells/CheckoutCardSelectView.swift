//
//  CheckoutCardSelectView.swift
//  Money2020
//
//  Created by Daniel Andrews on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class CheckoutCardSelectView: UIView {
    
    var card: UIImageView!
    var add: UIButton!
    var label: UILabel!
    var name: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        card = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 375))
        card.center = CGPoint(x: center.x, y: center.y)
        card.layer.cornerRadius = 20
        card.contentMode = .scaleAspectFill
        card.layer.shadowRadius = 3
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.2
        addSubview(card)
        
        let visa = UIImageView(frame: CGRect(x: 20, y: 20, width: 200, height: 70))
        visa.image = #imageLiteral(resourceName: "visa_logo")
        visa.contentMode = .scaleAspectFit
        card.addSubview(visa)
        
        name = UILabel(frame: CGRect(x: 10, y: card.frame.height-200, width: card.frame.width*(1/2), height:card.frame.height*(1/4)))
        name.font = name.font.withSize(40)
        name.textColor = UIColor.white
        visa.addSubview(name)
        
        let cardNum = UILabel(frame: CGRect(x: 10, y: card.frame.height-125, width: card.frame.width*(1/2), height:card.frame.height*(1/4)))
        cardNum.text = "**** 4537"
        cardNum.font = name.font.withSize(35)
        cardNum.textColor = UIColor.white
        visa.addSubview(cardNum)
        
        let expire = UILabel(frame: CGRect(x: card.frame.width-200, y: cardNum.frame.minY, width: 200, height: card.frame.height*(1/4)))
        expire.text = "Exp 04/21"
        expire.font = expire.font.withSize(30)
        expire.textColor = UIColor.white
        visa.addSubview(expire)
        
        let topColor = UIColor(red: 235/255, green: 51/255, blue: 73/255, alpha: 1)
        let bottomColor = UIColor(red: 244/255, green: 92/255, blue: 67/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 0.5]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = card.bounds
        gradientLayer.cornerRadius = 20
        card.layer.insertSublayer(gradientLayer, at: 0)
        
        
//        label = UILabel(frame: CGRect(x: card.frame.minX, y: card.frame.minY - 80, width: frame.width, height: frame.height))
//        label.text = "Checkout"
//        label.font = UIFont.boldSystemFont(ofSize: 60)
//        label.textColor = UIColor.black
//        label.sizeToFit()
//        addSubview(label)
        
//        add = UIButton(frame: CGRect(x: frame.width - 80, y: 40, width: 60, height: 60))
//        add.backgroundColor = UIColor.blue
//        add.setTitle("+", for: .normal)
//        add.titleLabel!.font = label.font.withSize(50)
//        add.setTitleColor(UIColor.white, for: .normal)
//        add.layer.cornerRadius = add.frame.width / 2
//        addSubview(add)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


