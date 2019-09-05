//
//  LireUIExtensions.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/4/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

/*
 This file is used to add any extensions used by the views
 */

// MARK: - UIFont
extension UIFont {
    
    static func lireBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: size)!
    }
    static func lireNormalFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static var smallFontTitle: UIFont {
        return lireBoldFont(size: 22)
    }
    
    static var largeFontTitle: UIFont {
        return lireBoldFont(size: 30)
    }
    
}

// MARK: - UIColor
extension UIColor {
    
    static var lireGreen: UIColor {
        return UIColor(red:0.49, green:0.63, blue:0.29, alpha:1.0)
    }
    static var blueButtonColor: UIColor {
        return UIColor(red:0.44, green:0.62, blue:0.76, alpha:1.0)
    }
    static var greenButtonColor: UIColor {
        return UIColor(red:0.42, green:0.55, blue:0.24, alpha:1.0)
    }
    static var redButtonColor: UIColor {
        return UIColor(red:0.76, green:0.45, blue:0.44, alpha:1.0)
    }
    static var highlightedNavButtonColor: UIColor {
        return UIColor(red:1.00, green:0.96, blue:0.73, alpha:1.0)
    }
}

// MARK: - UIImage
extension UIImageView {
    
    func setImageFrom(_ book: Books?) {
        // Set the image from the book object
        guard let finalBook = book, let url = finalBook.imageLink  else {
            self.image = UIImage(named: "img_nocover")
            return }
        Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Set default image
                return
            }
            self.image = image
        }
    }
}


// MARK: - String
extension String {
    
    func buttonAttributedText() -> NSAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.lireNormalFont(size: 22), .foregroundColor: UIColor.white]
        
        let text = NSAttributedString(string: self, attributes: attributes)
        
        return text
        
    }
}
