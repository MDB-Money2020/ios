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
    
    func loadCurrentOrder() {
        if let order = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            currOrder = order
        } else {
            currOrder = Order(items: [], restaurantId: restaurant.restaurantId!)
        }
        orderItems = (currOrder?.getOrderItems())!
        tableView.reloadData()
    }
    
    func setupNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Checkout"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "x"), style: .plain, target: self, action: #selector(dismissVC))
        navigationController?.navigationBar.tintColor = UIColor(hex: "#494949")
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    func setupPlaceOrderButton() {
        placeOrderButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        placeOrderButton.backgroundColor = UIColor(hex: "#6ECC3D")
        placeOrderButton.setTitle("PLACE ORDER", for: .normal)
        placeOrderButton.setTitleColor(.white, for: .normal)
        placeOrderButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 14)
        placeOrderButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        placeOrderButton.isHidden = true
        view.addSubview(placeOrderButton)
    }

    func setupTableView() {
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckoutItemTableViewCell.self, forCellReuseIdentifier: "itemCell")
        tableView.register(CheckoutTotalTableViewCell.self, forCellReuseIdentifier: "totalCell")
        tableView.register(CheckoutCardTableViewCell.self, forCellReuseIdentifier: "cardInfoCell")
        tableView.register(CheckoutCommentsTableViewCell.self, forCellReuseIdentifier: "commentsCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(hex: "#EEEFF0")
        tableView.allowsSelection = true
        view.addSubview(tableView)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    }
    func placeOrder() {
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
            statusView.hideAfter(delay: 0.75, completion: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func closeKeyboard() {
        view.endEditing(true)
    }

    func updateCartWithQuantity(menuItem: MenuItem, newQuantity: Int) {
        var order: Order!
        if let currOrder = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            order = currOrder
        } else {
            order = Order(items: [], restaurantId: menuItem.restaurantId!)
        }
        order.updateQuantityForItem(orderItemId: (selectedItem?.orderItemId)!, newQuantity: newQuantity)
        InstantLocalStore.saveCurrOrder(order: order)
    }
    func updateUIAfterUpdateCart() {
        statusView.alpha = 0
        statusView.show(inView: (navigationController?.view)!)

        SpringAnimation.springWithCompletion(duration: 0.5, animations: { _ in
            self.itemDetailView.frame = self.statusView.frame
        }, completion: { _ in
            self.modalView.dismiss()
            self.statusView.alpha = 1
            self.statusView.displayMessage(text: "Cart Updated!")
            self.statusView.hideAfter(delay: 1.0, completion: nil)
        })
    }
    func showItemDetailView(forItem: MenuItem) {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var mode: MenuItemDetailViewMode = .add
        itemDetailView = MenuItemDetailView(frame: CGRect(x: 15, y: 70, width: view.frame.width - 30, height: view.frame.height - 75 - (110 - navBarHeight! - statusBarHeight)), item: forItem, mode: mode)
        itemDetailView.delegate = self
        itemDetailView.setQuantity(quantity: (selectedItem?.quantity)!)
        modalView = ModalView(view: itemDetailView)
        modalView.dismissAnimation = .FadeOut
        modalView.dismissCompletion = {
            self.refresh()
        }
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    
    func refresh() {
        loadCurrentOrder()
        //TODO: fix this
        self.statusView.hideAfter(delay: 0, completion: nil)
        self.placeOrderButton.isHidden = false
    }
}

extension CheckoutViewController: MenuItemDetailViewDelegate {
    func dismissMenuItemDetailView() {
        modalView.dismiss()
    }

    func addItemToCart(item: MenuItem, quantity: Int) {
        //Do nothing
    }

    func updateCart(item: MenuItem, newQuantity: Int) {
        updateCartWithQuantity(menuItem: item, newQuantity: newQuantity)
        updateUIAfterUpdateCart()
        modalView.dismiss()
    }


}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return orderItems.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardInfoCell", for: indexPath) as! CheckoutCardTableViewCell
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            cell.awakeFromNib()
            
            cell.cardInfoLabel.text = "Visa Card Connected"
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CheckoutCommentsTableViewCell
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            cell.awakeFromNib()
            
            cell.commentsTextField.delegate = self
            
            return cell
            
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! CheckoutTotalTableViewCell
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            cell.awakeFromNib()
            
            cell.infoLabel.text = "Total"
            
            cell.valueLabel.text = InstantUtils.doubleToCurrencyString(val: currOrder!.getTotal())
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CheckoutItemTableViewCell
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            cell.awakeFromNib()
            
            print(indexPath.section - 1)
            let item = orderItems[indexPath.item]
            let quantity = item.quantity
            cell.priceLabel.text = InstantUtils.doubleToCurrencyString(val: (item.menuItemPrice)!)
            
            cell.quantityLabel.text = String(describing: quantity!)
            cell.nameLabel.text = item.menuItemName!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 80
        } else if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            return 80
        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 2 {
            return
        }
        let item = orderItems[indexPath.item]
        selectedItem = item
        firstly {
            return MenuItem.get(id: item.menuItemId!)
        }.then { menuItem -> Void in
            self.showItemDetailView(forItem: menuItem)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if indexPath.item >= orderItems.count {
                return //this is a hack lol
            }
            let item = orderItems[indexPath.item]
            currOrder?.removeItem(withId: item.orderItemId!)
            InstantLocalStore.saveCurrOrder(order: currOrder!)
            loadCurrentOrder()
        }
    }
    
    
}

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



