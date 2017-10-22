//
//  MenuItemUI.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit

extension MenuViewController {
    // MARK: UI Setup Methods
    
    func setupNavbar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Menu"
        navigationController?.navigationBar.tintColor = UIColor(hex: "#494949")
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "SFUIText-Regular", size: 17)!]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupFaceRecView() {
        faceRecView = FaceRecView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        faceRecView.delegate = self
        view.addSubview(faceRecView)
    }
    
    func setupCheckoutButton() {
        checkoutButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        checkoutButton.backgroundColor = UIColor(hex: "#6ECC3D")
        checkoutButton.setTitle("CHECKOUT", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 14)
        checkoutButton.isHidden = true
        numLabel = UILabel(frame: CGRect(x: 90, y: (checkoutButton.frame.height - 25)/2, width: 25, height: 25))
        numLabel.font = UIFont(name: "SFUIText-Medium", size: 14)
        numLabel.textAlignment = .center
        numLabel.textColor = .white
        numLabel.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        numLabel.layer.cornerRadius = numLabel.frame.width/2
        numLabel.clipsToBounds = true
        checkoutButton.addSubview(numLabel)
        checkoutButton.addTarget(self, action: #selector(toCheckout), for: .touchUpInside)
        view.addSubview(checkoutButton)
        
        updateUIWithCart()
    }
    

}
