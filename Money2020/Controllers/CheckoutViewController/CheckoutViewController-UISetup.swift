//
//  CheckoutViewController-UISetup.swift
//  Money2020
//
//  Created by Sahil Lamba on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit


extension CheckoutViewController {
    func setupNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Checkout"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "x"), style: .plain, target: self, action: #selector(dismissVC))
        navigationController?.navigationBar.tintColor = UIColor(hex: "#494949")
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "SFUIText-Regular", size: 17)!]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckoutItemTableViewCell.self, forCellReuseIdentifier: "itemCell")
        tableView.register(CheckoutTotalTableViewCell.self, forCellReuseIdentifier: "totalCell")
        tableView.register(CheckoutCardTableViewCell.self, forCellReuseIdentifier: "cardInfoCell")
        tableView.register(CheckoutCommentsTableViewCell.self, forCellReuseIdentifier: "commentsCell")
        tableView.register(CheckoutOrderDetailsTitleTableViewCell.self, forCellReuseIdentifier: "orderDetailsCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor(hex: "#EEEFF0")
        tableView.allowsSelection = true
        view.addSubview(tableView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    }
    
    func setupPlaceOrderButton() {
        placeOrderButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 80))
        placeOrderButton.backgroundColor = UIColor(hex: "#6ECC3D")
        placeOrderButton.setTitle("PLACE ORDER", for: .normal)
        placeOrderButton.setTitleColor(.white, for: .normal)
        placeOrderButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 28)
        placeOrderButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        placeOrderButton.isHidden = true
        view.addSubview(placeOrderButton)
    }
    
}
