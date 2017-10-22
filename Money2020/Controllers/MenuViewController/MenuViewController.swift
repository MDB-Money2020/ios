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
import AVFoundation
import PageMenu

class MenuViewController: UIViewController, UINavigationControllerDelegate {
    
    var restaurant: Restaurant!
    var user: User?
    
    var categoryToMenuItem = [String: [MenuItem]]()
    var filteredCategoryToMenuItem = [String: [MenuItem]]()
    var modalView: ModalView!
    var itemDetailView: MenuItemDetailView!
    var checkoutButton: UIButton!
    var numLabel: UILabel!
    let categories = ["Suggestions", "Appetizers", "Entrees", "Salads", "Desserts"]
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [MenuCategoryViewController] = []
    
    //Search
    var searchBar: UISearchBar!
    var headerView: UIView!
    var searchWord: String?
    var debounceTimer: Timer?
    
    //FaceId
    var faceIdService = FaceIdService()
    var faceRecView: FaceRecView!
    var helloView: HelloView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupSearchBar()
        setupFaceRecView()
        setupPageMenu()
        setupCheckoutButton()
        loadMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNotificationObservers()
        updateUIWithCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeNotificationObservers()
    }
    
    //MARK: Data Populating Methods
    
    func refresh() {
        updateUIWithCart()
        loadMenu()
        loadSuggestedMenuItems()
    }
    
    func loadMenu() {
        firstly {
            return Restaurant.getMenuItems(restaurantId: restaurant.restaurantId!)
        }.then { retrievedItems -> Void in
            for item in retrievedItems {
                if var items = self.categoryToMenuItem[item.category!] {
                    if !items.contains(where: { $0.menuItemId == item.menuItemId }) {
                        items.append(item)
                        self.categoryToMenuItem[item.category!] = items
                    }
                } else {
                    self.categoryToMenuItem[item.category!] = [item]
                }
            }
            self.filteredCategoryToMenuItem = self.categoryToMenuItem
        
            DispatchQueue.main.async {
                self.updateCategoryVCs(categoryToMenuItems: self.filteredCategoryToMenuItem)
            }
        }.catch(policy: .allErrors) { error in
            log.error(error.localizedDescription)
        }
    }
    
    func loadSuggestedMenuItems() {
        guard let currUserId = InstantLocalStore.getCurrUserId() else { return }
        firstly {
            return Restaurant.getMenuSuggestions(userId: currUserId, restaurantId: restaurant.restaurantId!)
        }.then { suggestedItems -> Void in
            for item in suggestedItems {
                if var items = self.categoryToMenuItem["Suggestions"] {
                    if !items.contains(where: { $0.menuItemId == item.menuItemId }) {
                        items.append(item)
                        self.categoryToMenuItem["Suggestions"] = items
                    }
                } else {
                    self.categoryToMenuItem["Suggestions"] = [item]
                }
            }
            self.filteredCategoryToMenuItem = self.categoryToMenuItem
            DispatchQueue.main.async {
                self.updateCategoryVCs(categoryToMenuItems: self.filteredCategoryToMenuItem)
            }
        }.catch(policy: .allErrors) { error in
            log.error(error.localizedDescription)
        }
    }
    
    
    // MARK: User Auth Handlers
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: NotificationTable.userSignedIn, object: nil)
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NotificationTable.userSignedIn, object: nil)
    }
    
    @objc func handle(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any] {
            if let user = User(JSON: userInfo) {
                if user.userId != nil && user.userId != InstantLocalStore.getCurrUserId() {
                    self.user = user
                    InstantLocalStore.clearCurrOrder(atRestaurantId: "-Kx0rrVSISYN1ZmefG8_")
                    InstantLocalStore.setCurrUserId(userId: user.userId!)
                    user.getProfPic().then { img in
                        DispatchQueue.main.async {
                            self.helloView.populate(fullName: user.fullName!, image: img)
                        }
                    }
                    refresh()
                }
            }
        }
    }
    
    //MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheckout" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! CheckoutViewController
            destVC.restaurant = restaurant
            destVC.user = user
        }
    }
    
    @objc func toCheckout() {
        performSegue(withIdentifier: "toCheckout", sender: self)
    }
  

}

//MARK: FaceRecView Delegate Methods

extension MenuViewController: FaceRecViewDelegate {
    func handleNewImage(image: UIImage) {
        faceIdService.handle(image: image)
    }
}
