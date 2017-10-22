//
//  CheckoutViewController-TableView.swift
//  Money2020
//
//  Created by Sahil Lamba on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

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
            return 600
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
