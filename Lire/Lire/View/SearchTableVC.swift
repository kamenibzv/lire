//
//  SearchTableVC.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/1/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwipeCellKit

class SearchTableVC: UIViewController {
    /*
     This class presents the the data from the presenter which is called from the API
     */
    
    // Define properties
    private let realm = try! Realm()
    private let presenter = LireDataPresenter()
    
    private var resultFromCall: [Books]? {
        didSet {
            // Reload the table view each time this is set
            tableView.reloadData()
        }
    }
    
    private let noSearchingText = "Search your favorite books and swipe right to add to your wish list"
    
    private lazy var tableView: UITableView = {
        // Table View for this class
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height))
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        return tv
    }()
    
    private lazy var labelForText: UILabel = {
        // This label is used to inform the user about what is happening as well what to do
        let label = UILabel(frame: CGRect(x: ScreenSize.width/2, y: ScreenSize.height/2, width: ScreenSize.width, height: 200))
        label.center = self.view.center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var indicateActivity: UIActivityIndicatorView = {
        // Activity indicator to show user that there is searching going on
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        
       return indicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        // Search Bar to perform search
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 40))
        bar.delegate = self
        bar.placeholder = "Search Your Favorite Book"
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupview()
    }
    
    private func setupview() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        view.addSubview(labelForText)
        view.addSubview(tableView)
        view.addSubview(indicateActivity)
        
        presenter.delegate = self
        
        tableView.isHidden = true
        labelForText.text = noSearchingText
        tableView.register(LireCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard once the screen (the UIView and not the table view)s is touched
        searchBar.endEditing(true)
    }
    

}

// MARK: - Search Delegate

extension SearchTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // call the API here
        presenter.performSearch(with: searchText)

    }

}

// MARK: - Table view Delegate and Datasource

extension SearchTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disable the searchBar when scrolling
        searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultFromCall?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LireCell
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.updateCell(book: resultFromCall?[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.endEditing(true)
        let vc = DetailViewController()
        vc.book = resultFromCall?[indexPath.row]
        // hide the bottom bar
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        // this shows it
        hidesBottomBarWhenPushed = false
    }
    
}

// MARK: - Swipe Cell Delegate

extension SearchTableVC: SwipeTableViewCellDelegate {
    // Implement swiping of the cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // Setting the orientation we want to trigger the add action
        guard orientation == .left else { return nil }
        
        // Setting the add action
        let addAction = SwipeAction(style: .default, title: "Add") { action, indexPath in
            
            // check and add if the item is in realm before addind
            if let doc = self.resultFromCall {
                let book = doc[indexPath.row]
                if !book.isInDatabase() {
                    book.addToDatabase()
                    print("Added to DB")
                }
            }

        }
        // Set the image based on wether or not the object is already in the database
        addAction.backgroundColor = UIColor.lireGreen
        addAction.image = UIImage(named: "icn_wishlist")
        return [addAction]
    }
    
}

// MARK: - Presenter Delegate
extension SearchTableVC: DataPresenterProtocol {
    
    func emptryStringDetected() {
        // Stop any indicators and and reset array. This is because sometimes the response arrives after cancel is pressed
        resultFromCall?.removeAll()
        indicateActivity.stopAnimating()
        labelForText.text = noSearchingText
        tableView.isHidden = true
    }
    
    func clearBackgroundLabel() {
        // Clears background text and starts animating
        labelForText.text = ""
        indicateActivity.startAnimating()
    }
    
    func resultsWithData(data: [Books]) {
        // Update tableview with data
        resultFromCall = data
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func stopViewAnimation() {
        // Stop animating
        indicateActivity.stopAnimating()
    }
    
    func resultIsEmpty(forText: String) {
        // Hide tableviw and show text
        self.tableView.isHidden = true
        self.labelForText.text = "Couldn't find \(forText) \nPlease search another book"
    }
    
    func errorSearching(_ string: String) {
        // Tell users there was an error serching
        indicateActivity.stopAnimating()
        tableView.isHidden = true
        labelForText.text = "Couldn't find \(string) \nPlease check your connection and try again"
    }
    
    
}
