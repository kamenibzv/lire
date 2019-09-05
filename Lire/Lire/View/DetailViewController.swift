//
//  DetailViewController.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/3/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    /*
     This view is used to show details about the book users selected
     */
    
    var book: Books? {
        
        didSet {
            // Configure the view to show the right data
            var author = ""
            if let thisBook = book{
                author = thisBook.authorName.joined(separator: ", ")
                // Set text of addRemoveFromWishlist button
                if thisBook.isInDatabase(){
                    addRemoveFromWishlist.setAttributedTitle("Remove from Wishlist".buttonAttributedText(), for: .normal)
                }
                else {
                    addRemoveFromWishlist.setAttributedTitle("Add to Wishlist".buttonAttributedText(), for: .normal)
                }
            }
            authorText.text = author.isEmpty ? "No Author" : "by \(author)"
            titleText.text = book?.title ?? "No Title"
            bookImage.setImageFrom(book)
            
        }
    }
    
    // Get height of navbar plus status bar
    private var navBarPlusStatusbar : CGFloat{
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            }else{
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                let barHeight = self.navigationController?.navigationBar.frame.height ?? 44.0
                // Noticed that bar height returns 0 when setting the image view so set a default of 44 for case like that so image view isn't pushed all the way close to the status bar
                return barHeight + statusBarHeight
            }
        }
    }
    
    
    // Define views
    private lazy var bookImage: UIImageView = {
        
        let screenHeightToWorkWith = ScreenSize.height - (self.navBarPlusStatusbar * 2.5)
        let x: CGFloat = ScreenSize.width * (70/375)
        let y = self.navBarPlusStatusbar
        let height: CGFloat = screenHeightToWorkWith * (325/532)
        let width: CGFloat = ScreenSize.width * (235/375)

        let imageView = UIImageView()
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_nocover")
        
        return imageView
    }()
    
    private lazy var titleText: UILabel = {
        
        let screenHeightToWorkWith = ScreenSize.height - (self.navBarPlusStatusbar * 2.5)
        let x: CGFloat = 16
        let y = self.navBarPlusStatusbar + self.bookImage.frame.height + 20
        let height: CGFloat = screenHeightToWorkWith * (35/532)
        let width: CGFloat = ScreenSize.width - (x * 2)
        
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var authorText: UILabel = {
        
        let screenHeightToWorkWith = ScreenSize.height - (self.navBarPlusStatusbar * 2.5)
        let x: CGFloat = 16
        let y = self.titleText.frame.origin.y + self.titleText.frame.height
        let height: CGFloat = screenHeightToWorkWith * (25/532)
        let width: CGFloat = ScreenSize.width - (x * 2)
        
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        
        // text size 18
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var viewBookButton: UIButton = {
        
        let screenHeightToWorkWith = ScreenSize.height - (self.navBarPlusStatusbar * 2.5)
        let x: CGFloat = ScreenSize.width * (20/375)
        let y = self.authorText.frame.origin.y + self.authorText.frame.height + 20
        let height: CGFloat = screenHeightToWorkWith * (60/532)
        let width: CGFloat = ScreenSize.width - (x * 2)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.blueButtonColor
        button.setAttributedTitle("Learn More".buttonAttributedText(), for: .normal)
        button.addTarget(self, action: #selector(goToBookWebpage(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addRemoveFromWishlist: UIButton = {
        
        let screenHeightToWorkWith = ScreenSize.height - (self.navBarPlusStatusbar * 2.5)
        let x: CGFloat = ScreenSize.width * (20/375)
        let y = self.viewBookButton.frame.origin.y + self.viewBookButton.frame.height + 20
        let height: CGFloat = screenHeightToWorkWith * (60/532)
        let width: CGFloat = ScreenSize.width - (x * 2)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.greenButtonColor
        button.addTarget(self, action: #selector(addOrRemoveFromWishList(sender:)), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset the navBar for the parent view
        resetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setup view here so when user leaves to safari and comes back, the view stays the same
        setupView()
    }
    
    private func setupView() {
        self.hidesBottomBarWhenPushed = true // Keeps the bottom bar hidden if you leave this page
        // Make nav bar background transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white
        
        view.addSubview(bookImage)
        view.addSubview(titleText)
        view.addSubview(authorText)
        view.addSubview(viewBookButton)
        view.addSubview(addRemoveFromWishlist)
        
    }
    
    private func resetView() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // Mark:- Button Selectors
    
    @objc func addOrRemoveFromWishList(sender: UIButton!) {
        // Add or remove book from database
        if let thisBook = book{
            // Set text and action of addRemoveFromWishlist button and add or delete item
            if thisBook.isInDatabase(){
                thisBook.removeFromDatabase()
                sender.isHidden = true
                viewBookButton.isHidden = true // This is to avoid crashing as the object has been deleted
            }
            else {
                thisBook.addToDatabase()
                sender.setAttributedTitle("Remove from Wishlist".buttonAttributedText(), for: .normal)
            }
        }
    }
    
    @objc func goToBookWebpage(sender: UIButton!) {
        // To to Open Library to see more info about the book
        guard let book = book, let url = book.bookURL else {return}
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true)
    }

}
