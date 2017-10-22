//
//  MenuViewController.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import PromiseKit
import Spring

class MenuViewController: UIViewController, UINavigationControllerDelegate {
    
    var collectionView: UICollectionView!
    var restaurant: Restaurant!
    var user: User?
    var categoryToMenuItem = [String: [MenuItem]]()
    var filteredCategoryToMenuItem = [String: [MenuItem]]()
    var modalView: ModalView!
    var itemDetailView: MenuItemDetailView!
    var checkoutButton: UIButton!
    var numLabel: UILabel!
    var searchBar: UISearchBar!
    var headerView: UIView!
    var searchWord: String?
    var debounceTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupSearchBar()
        setupCollectionView()
        setupCheckoutButton()
        
        firstly {
            return Restaurant.getMenuItems(restaurantId: restaurant.restaurantId!)
        }.then { retrievedItems -> Void in
            for item in retrievedItems {
                if var items = self.categoryToMenuItem[item.category!] {
                    items.append(item)
                    self.categoryToMenuItem[item.category!] = items
                } else {
                    self.categoryToMenuItem[item.category!] = [item]
                }
            }
            self.filteredCategoryToMenuItem = self.categoryToMenuItem
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupNavbar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Menu"
        navigationController?.navigationBar.tintColor = UIColor(hex: "#494949")
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUIWithCart()
    }
    
    func updateUIWithCart() {
        if let order = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            if order.getNumMenuItems() > 0 {
                numLabel.text = String(order.getNumMenuItems())
                checkoutButton.isHidden = false
            } else {
                numLabel.text = "0"
                checkoutButton.isHidden = true
            }
        } else {
            numLabel.text = "0"
            checkoutButton.isHidden = true
        }
    }
    
    func addToCart(item: MenuItem, quantity: Int, withOptions: [Option]) {
        var order: Order!
        if let currOrder = InstantLocalStore.getCurrOrder(atRestaurantId: restaurant.restaurantId!) {
            order = currOrder
        } else {
            order = Order(items: [], restaurantId: item.restaurantId!)
        }
        let orderItem = OrderItem(menuItemId: item.menuItemId!, menuItemName: item.title!, quantity: quantity, menuItemPrice: item.price!)
        order.addItem(item: orderItem)
        InstantLocalStore.saveCurrOrder(order: order)
    }
    
    func updateUIAfterAddToCart() {
        let statusView = StatusView()
        statusView.alpha = 0
        statusView.show(inView: (navigationController?.view)!)
        
        SpringAnimation.springWithCompletion(duration: 0.5, animations: { _ in
            if self.itemDetailView != nil {
                self.itemDetailView.frame = statusView.frame
            }
        }, completion: { _ in
            self.modalView.dismiss()
            statusView.alpha = 1
            statusView.displayMessage(text: "Added to Cart!")
            statusView.hideAfter(delay: 0.65, completion: nil)
            if self.checkoutButton.isHidden {
                self.checkoutButton.frame.origin.y = self.view.frame.height
                self.checkoutButton.isHidden = false
                SpringAnimation.springEaseIn(duration: 0.3, animations: { _ in
                    self.checkoutButton.frame.origin.y = self.view.frame.height - self.checkoutButton.frame.height
                })
            }
            self.updateUIWithCart()
        })
    }
    
    func setupSearchBar() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height
        headerView = UIView(frame: CGRect(x: -1, y: statusBarHeight + navBarHeight!, width: view.frame.width + 2, height: 45))
        headerView.layer.borderColor = UIColor(hex: "#EEEFF0").cgColor
        headerView.layer.borderWidth = 0.8
        headerView.backgroundColor = .white
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45))
        searchBar.placeholder = " Search menu..."
        searchBar.barStyle = .blackOpaque
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.layer.borderWidth = 0
        searchBar.layer.cornerRadius = 3
        searchBar.clipsToBounds = true
        searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 13)!], for: .normal)
        
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.font = UIFont(name: "SFUIText-Regular", size: 12)
        searchField?.backgroundColor = .white
        searchField?.textColor = UIColor(hex: "#9299A0")
        searchField?.borderStyle = .none
        headerView.addSubview(searchBar)
        view.addSubview(headerView)
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
    
    func toCheckout() {
        performSegue(withIdentifier: "toCheckout", sender: self)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: headerView.frame.maxY, width: view.frame.width, height: view.frame.height - headerView.frame.maxY), collectionViewLayout: layout)
        collectionView.register(MenuItemCollectionViewCell.self, forCellWithReuseIdentifier: "menuItemCell")
        collectionView.register(MenuHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    func searchMenu() {
        filteredCategoryToMenuItem = [String: [MenuItem]]()
        if searchWord == "" || searchWord == nil {
            filteredCategoryToMenuItem = categoryToMenuItem
        } else {
            for (_, items) in categoryToMenuItem {
                for item in items {
                    //TODO
                    if (item.category?.lowercased().contains((searchWord?.lowercased())!))! || (item.title?.lowercased().contains((searchWord?.lowercased())!))! || (item.description?.lowercased().contains((searchWord?.lowercased())!))! {
                        if var catItems = filteredCategoryToMenuItem[item.category!] {
                            catItems.append(item)
                            filteredCategoryToMenuItem[item.category!] = catItems
                        } else {
                            filteredCategoryToMenuItem[item.category!] = [item]
                        }
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheckout" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! CheckoutViewController
            destVC.restaurant = restaurant
        }
    }

    func showItemDetailView(forItem: MenuItem) {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var mode: MenuItemDetailViewMode = .add
        itemDetailView = MenuItemDetailView(frame: CGRect(x: 15, y: 70, width: view.frame.width - 30, height: view.frame.height - 75 - (110 - navBarHeight! - statusBarHeight)), item: forItem, mode: mode)
        itemDetailView.delegate = self
        modalView = ModalView(view: itemDetailView)
        modalView.dismissAnimation = .FadeOut
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    

}

extension MenuViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchMenu()
        searchBar.showsCancelButton = true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWord = searchBar.text!
        
        if let timer = debounceTimer {
            timer.invalidate()
        }
        
        debounceTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(searchMenu), userInfo: nil, repeats: false)
        RunLoop.current.add(debounceTimer!, forMode: .defaultRunLoopMode as RunLoopMode)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        filteredCategoryToMenuItem = categoryToMenuItem
        collectionView.reloadData()
    }
    
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategoryToMenuItem.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! MenuItemCollectionViewCell
        let item = filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[indexPath.section]]?[indexPath.item]
        cell.nameLabel.text = item?.title!
        cell.descriptionLabel.text = item?.description!
        cell.priceLabel.text = InstantUtils.doubleToCurrencyString(val: (item?.price)!)
        
        firstly {
            return (item?.getImage())!
            }.then { img -> Void in
                cell.foodImageView.image = img
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MenuHeaderCollectionReusableView
            for subview in headerView.subviews {
                subview.removeFromSuperview()
            }
            headerView.awakeFromNib()
            headerView.titleLabel.text = Array(filteredCategoryToMenuItem.keys)[indexPath.section]
            
            return headerView
            
        default:
            
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredCategoryToMenuItem[Array(filteredCategoryToMenuItem.keys)[indexPath.section]]?[indexPath.item]
        showItemDetailView(forItem: item!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numSections = filteredCategoryToMenuItem.keys.count
        if section == numSections - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension MenuViewController: MenuItemDetailViewDelegate {
    
    func dismissMenuItemDetailView() {
        modalView.dismiss()
    }
    
    func addItemToCart(item: MenuItem, quantity: Int) {
        addToCart(item: item, quantity: quantity, withOptions: [])
        updateUIAfterAddToCart()
    }
    
    func updateCart(item: MenuItem, newQuantity: Int) {
        //Do nothing
    }
}
