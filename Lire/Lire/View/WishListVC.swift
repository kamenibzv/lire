//
//  WishListVC.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/1/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class WishListVC: UIViewController {
    /*
     This class is used to show books the user has saved
    */
    
    // Define attributes
    private let realm = try! Realm()
    private let backgroundText = "Search and add books to your wishlist. Swipe left to remove from wishlist!"
    
    private var myWishList: Results<Books>? {
        // This object is used to hold the data from realm and update the tableView
        didSet {
            // Update the tableView's background text and reload it
            let tableViewLabel = tableView.backgroundView as! UILabel

            if let wishList = myWishList {
                // Check if myWishList is empty and add or remove background text
                tableView.reloadData()  // Could have written an if else and
                tableViewLabel.text = wishList.isEmpty ? backgroundText : ""
                
            } else {
                tableViewLabel.text = backgroundText
            }
            
        }
    }
    
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height))
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        
        // Set its background view for when there are no cells
        let backGroundLabel = UILabel(frame: .zero)
        backGroundLabel.font = UIFont.boldSystemFont(ofSize: 24)
        backGroundLabel.textColor = .black
        backGroundLabel.numberOfLines = 0
        backGroundLabel.textAlignment = NSTextAlignment.center
        backGroundLabel.text = self.backgroundText
        tv.backgroundView = backGroundLabel
        
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        // Set the view
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.register(LireCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calling this here to make sure the data is the most up to date. This function is called each time the view appears
        loadBooks()
    }
    
    private func loadBooks() {
        // Load books from database
        myWishList = realm.objects(Books.self)
    }
    

}

// MARK: - Tableview Data Source and Delegate

extension WishListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWishList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LireCell
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.updateCell(book: myWishList?[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.book = myWishList?[indexPath.row]
        // hide the bottom bar
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        // this shows it
        hidesBottomBarWhenPushed = false
    }
    
}

// MARK: - Swipe Cell Delegate

extension WishListVC: SwipeTableViewCellDelegate {
    
    // Implement swiping of the cell and action that happens
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // Setting the orientation we want to trigger the delete action
        guard orientation == .right else { return nil }
        
        // Setting the delete action
        let deleteAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
            // Removing the item from the wishlist
            if let wishList = self.myWishList{
                wishList[indexPath.row].removeFromDatabase()
                self.loadBooks()
            }
        }
        // Set the delete action image
        deleteAction.backgroundColor = UIColor.redButtonColor
        deleteAction.image = UIImage(named: "icn_remove")
        
        return [deleteAction]
    }
    
}
