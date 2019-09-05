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
                realm.delete(self)
            }
        } catch {
            print("Error deleting Category: \(error)")
        }
    }
}
