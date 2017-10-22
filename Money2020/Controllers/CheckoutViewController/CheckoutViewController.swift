//
//  CheckoutViewController.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import PromiseKit
import Spring

class CheckoutViewController: UIViewController, UINavigationControllerDelegate {

    var restaurant: Restaurant!
    var tableView: UITableView!
    var currOrder: Order?
    var orderItems = [OrderItem]()
    var placeOrderButton: UIButton!
    var itemDetailView: MenuItemDetailView!
    var selectedItem: OrderItem?
    var tapGesture: UITapGestureRecognizer!
    var activeField: UITextField?
    var modalView: ModalView!
    var statusView: StatusView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setNeedsStatusBarAppearanceUpdate()
        setupTableView()
        setupPlaceOrderButton()
        statusView = StatusView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.statusView.show(inView: view)
        refresh()
    }
    
    //Data Population
    func loadCurrentOrder() {
        if let order = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            currOrder = order
        } else {
            currOrder = Order(items: [], restaurantId: restaurant.restaurantId!)
        }
        orderItems = (currOrder?.getOrderItems())!
        tableView.reloadData()
    }
    
    func refresh() {
        loadCurrentOrder()
        //TODO: fix this
        self.statusView.hideAfter(delay: 0, completion: nil)
        self.placeOrderButton.isHidden = false
    }
    
    //Segues and App Flow
    @objc   
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    
    @objc func placeOrder() {
        currOrder = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!)
        if currOrder == nil {
            return
        }
        let statusView = StatusView()
        statusView.show(inView: (navigationController?.view)!)
        let currUserId = InstantLocalStore.getCurrUserId()
        let commentsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CheckoutCommentsTableViewCell
        if commentsCell.commentsTextField.text != nil && commentsCell.commentsTextField.text != "" {
            currOrder?.additionalInstructions = commentsCell.commentsTextField.text!
        }
        firstly {
            return PaymentHelper.placeOrder(order: currOrder!)
        }.then { _ -> Void in
            InstantLocalStore.clearCurrOrder(atRestaurantId: self.restaurant.restaurantId!)
            self.placeOrderButton.isHidden = true
            statusView.displayMessage(text: "Order Placed!")
            statusView.hideAfter(delay: 0.75, completion: {  () -> Void in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
  
}

//Text View Enhancements
extension CheckoutViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        tableView.addGestureRecognizer(tapGesture)
        activeField = textField
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.removeGestureRecognizer(tapGesture)
        textField.resignFirstResponder()
        activeField = nil
    }
}



