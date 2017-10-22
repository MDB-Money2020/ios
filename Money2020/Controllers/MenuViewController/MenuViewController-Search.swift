//
//  MenuItemSearchBar.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

extension MenuViewController {
    
    func setupSearchBar() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height
        headerView = UIView(frame: CGRect(x: -1, y: view.frame.height/3, width: view.frame.width + 2, height: 45))
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
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "SFUIText-Regular", size: 13)!], for: .normal)
        
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.font = UIFont(name: "SFUIText-Regular", size: 12)
        searchField?.backgroundColor = .white
        searchField?.textColor = UIColor(hex: "#9299A0")
        searchField?.borderStyle = .none
        headerView.addSubview(searchBar)
        view.addSubview(headerView)
    }
    
    @objc func searchMenu() {
        filteredCategoryToMenuItem = [String: [MenuItem]]()
        if searchWord == "" || searchWord == nil {
            filteredCategoryToMenuItem = categoryToMenuItem
        } else {
            for (_, items) in categoryToMenuItem {
                for item in items {
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
        DispatchQueue.main.async {
            self.updateCategoryVCs(categoryToMenuItems: self.filteredCategoryToMenuItem)
        }
    }
    
}

//MARK: Search Delegate Methods

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
        DispatchQueue.main.async {
            self.updateCategoryVCs(categoryToMenuItems: self.filteredCategoryToMenuItem)
        }
    }
    
}
