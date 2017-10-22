//
//  ItemDetailView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import PromiseKit

protocol MenuItemDetailViewDelegate {
    func dismissMenuItemDetailView()
    func addItemToCart(item: MenuItem, quantity: Int)
    func updateCart(item: MenuItem, newQuantity: Int)
}

enum MenuItemDetailViewMode {
    case add
    case updateAdd
}

class MenuItemDetailView: UIView {
    
    var foodImageView: UIImageView!
    var cancelButton: UIButton!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var addToCartButton: UIButton!
    var delegate: MenuItemDetailViewDelegate?
    var menuItem: MenuItem!
    var quantityLabel: UILabel!
    var quantity = 1
    var minusButton: UIButton!
    var plusButton: UIButton!
    var mode: MenuItemDetailViewMode!
    
    init(frame: CGRect, item: MenuItem, mode: MenuItemDetailViewMode) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white
        menuItem = item
        self.mode = mode
        
        foodImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 320))
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        addSubview(foodImageView)
        
        firstly {
            return item.getImage()
            }.then { img -> Void in
            self.foodImageView.image = img
        }
        
        cancelButton = UIButton(frame: CGRect(x: 15, y: 15, width: 18, height: 18))
        cancelButton.contentMode = .scaleAspectFill
        cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(cancelButton)
        
        nameLabel = UILabel(frame: CGRect(x: 20, y: foodImageView.frame.maxY + 30, width: frame.width - 40, height: 60))
        nameLabel.font = UIFont(name: "SFUIText-Regular", size: 28)
        nameLabel.textColor = UIColor(hex: "#212A31")
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.text = item.title!
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: 30, y: nameLabel.frame.maxY + 25, width: frame.width - 60, height: 300))
        descriptionLabel.font = UIFont(name: "SFUIText-Light", size: 21)
        descriptionLabel.textColor = UIColor(hex: "#4F606E")
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 8
        paragraphStyle2.alignment = .center
        var attrString2 = NSMutableAttributedString(string: item.description!)
        
        attrString2.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle2, range:NSMakeRange(0, attrString2.length))
        descriptionLabel.attributedText = attrString2
        descriptionLabel.sizeToFit()
        addSubview(descriptionLabel)
        
        minusButton = UIButton(frame: CGRect(x: (frame.width - 170)/2, y: descriptionLabel.frame.maxY + 40, width: 50, height: 50))
        minusButton.backgroundColor = UIColor(red:0.95, green:0.63, blue:0.18, alpha:1.0)
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.white, for: .normal)
        minusButton.setTitleColor(.lightGray, for: .disabled)
        minusButton.titleLabel?.font = UIFont(name: "SFUIText-Regular", size: 25)
        minusButton.layer.cornerRadius = minusButton.frame.width/2
        minusButton.addTarget(self, action:#selector(subQuantity), for: .touchUpInside)
        addSubview(minusButton)
        
        quantityLabel = UILabel(frame: CGRect(x: minusButton.frame.maxX + 10, y: minusButton.frame.minY, width: 40, height: 50))
        quantityLabel.font = UIFont(name: "SFUIText-Regular", size: 28)
        quantityLabel.textColor = .darkGray
        quantityLabel.textAlignment = .center
        quantityLabel.adjustsFontSizeToFitWidth = true
        quantityLabel.text = String(quantity)
        addSubview(quantityLabel)
        
        plusButton = UIButton(frame: CGRect(x: quantityLabel.frame.maxX + 10, y: minusButton.frame.minY, width: 50, height: 50))
        plusButton.backgroundColor = UIColor(red:0.95, green:0.63, blue:0.18, alpha:1.0)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont(name: "SFUIText-Regular", size: 25)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.setTitleColor(.lightGray, for: .disabled)
        plusButton.layer.cornerRadius = plusButton.frame.width/2
        plusButton.addTarget(self, action:#selector(addQuantity), for: .touchUpInside)
        addSubview(plusButton)
        
        addToCartButton = UIButton(frame: CGRect(x: 0, y: frame.height - 80, width: frame.width, height: 80))
        addToCartButton.backgroundColor = UIColor(hex: "#6ECC3D")
        if mode == .add {
            addToCartButton.setTitle("ADD TO CART", for: .normal)
        } else if mode == .updateAdd {
            addToCartButton.setTitle("UPDATE ORDER", for: .normal)
        }
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.setTitleColor(.lightGray, for: .disabled)
        addToCartButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 21)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        addSubview(addToCartButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuantity(quantity: Int) {
        self.quantity = quantity
        quantityLabel.text = String(quantity)
    }
    
    @objc func cancelButtonTapped() {
        delegate?.dismissMenuItemDetailView()
    }
    
    @objc func addToCartButtonTapped() {
        if mode == .add {
            delegate?.addItemToCart(item: menuItem, quantity: quantity)
        } else if mode == .updateAdd {
            delegate?.updateCart(item: menuItem, newQuantity: quantity)
        } 
    }
    
    @objc func addQuantity() {
        quantity += 1
        quantityLabel.text = String(quantity)
    }
    
    @objc func subQuantity() {
        if quantity == 0 {
            return
        }
        quantity -= 1
        quantityLabel.text = String(quantity)
    }
    
    func disable() {
        addToCartButton.isEnabled = false
        plusButton.isEnabled = false
        minusButton.isEnabled = false
        quantity = 0
        quantityLabel.text = "0"
    }
}
