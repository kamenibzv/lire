//
//  ViewController.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/1/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // This is the base and first view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Setup tab colors
        // place the tab view controllers in a navigation controller and set the tab bar
        let searchVC = UINavigationController(rootViewController: SearchTableVC())
        searchVC.tabBarItem.image = UIImage(named: "icn_search")
        searchVC.tabBarItem.selectedImage = UIImage(named: "icn_search_hl")
        
        let wishListVC = UINavigationController(rootViewController: WishListVC())
//        wishListVC.navigationItem.title = "Wishist"
        wishListVC.tabBarItem.image = UIImage(named: "icn_wishlist_sm")
        wishListVC.tabBarItem.selectedImage = UIImage(named: "icn_wishlist_hl")
        
        viewControllers = [searchVC, wishListVC]
    }

}

