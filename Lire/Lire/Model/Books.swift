//
//  Books.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/2/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import Foundation
import RealmSwift


struct Root: Decodable {
    var docs: [Books]?
}

class Books: Object, Decodable {
    /* This objects holds all the needed data from the api call. It is built to both be decodable and be a realm object
     */
    
    @objc dynamic var titleSuggest: String?
    var coverI = RealmOptional<Int>()
    @objc dynamic var title: String?
    var authorName = List<String>()
    @objc dynamic var key: String?
    
    var imageLink: URL? {
        // Returns a URL is there is a cover ID from the database
        guard let id = coverI.value else { return nil }
        guard let url = URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg") else { return nil }
        return url
    }
    var bookURL: URL? {
        // Returns the URL of the book
        return URL(string: "https://openlibrary.org\(key ?? "")")
    }
    
    private enum CodingKeys: String, CodingKey {
        case titleSuggest = "titleSuggest"
        case coverI = "coverI"
        case title
        case authorName = "authorName"
        case key
    }
    
    override static func primaryKey() -> String {
        return "key"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        titleSuggest = try container.decode(String.self, forKey: .titleSuggest)
        coverI.value = try container.decodeIfPresent(Int.self, forKey: .coverI) ?? 0
        title = try container.decode(String.self, forKey: .title)
        key = try container.decode(String.self, forKey: .key)
        
        let nameOfAuthors = try container.decodeIfPresent([String].self, forKey: .authorName) ?? [String()]
        authorName.append(objectsIn: nameOfAuthors)
    }
}


