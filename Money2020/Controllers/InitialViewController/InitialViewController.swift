//
//  InitialViewController.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()

        InstantLocalStore.clearCurrUserId()
        InstantLocalStore.clearCurrOrder(atRestaurantId: "-Kx0rrVSISYN1ZmefG8_")
    }

    override func viewDidAppear(_ animated: Bool) {
        Restaurant.get(withId: "-Kx0rrVSISYN1ZmefG8_").then { restaurant -> Void in
            self.restaurant = restaurant
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! MenuViewController
            destVC.restaurant = restaurant
        }
    }
    
    

}
