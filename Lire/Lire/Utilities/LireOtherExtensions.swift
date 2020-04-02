//
//  LireOtherExtensions.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/5/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import Foundation
import RealmSwift

/*
 This extensions are to add, remove and check if an object exist on realm 
 */
extension Books {
    
    func isInDatabase() -> Bool {
        // Checks if this object is already in the the database
        let realm = try! Realm()
        return realm.object(ofType: Books.self, forPrimaryKey: self.key) != nil
    }
}

extension Books {
    func addToDatabase() {
        // Add self to database
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Writing to Realm error: \(error)")
        }
    }
    
    func removeFromDatabase() {
        // Delete self from database
        let realm = try! Realm()
        
        do{
            try realm.write {
                /* Without this, there was "can only delete and object from the realm is belongs to" error
                 This was happening due to: adding to wishlish from the SearchTableVC, then going to WishListVC, then back to SearchTableVC, then details of the item, clicking on "Remove from Wishlist", then Back button.
                 The error was most likely because the realm object was changed when you go from the search to the wishlist page. Once the realm object changes the error occurs when you want to do just realm.delete()
                */
                if let productToDelete = realm.object(ofType: Books.self, forPrimaryKey: self.key) {
                    realm.delete(productToDelete)
                }
                
            }
        } catch {
            print("Error deleting Category: \(error)")
        }
    }
}
