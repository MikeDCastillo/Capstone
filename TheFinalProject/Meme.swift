//
//  Meme.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

struct Meme {
    
    var id: String
    var datePosted: Date
    var imageURL: URL
    
    init(id: String, datePosted: Date = Date(), imageURL: URL, entries: [String] = []) {
        self.id = id
        self.datePosted = datePosted
        self.imageURL = imageURL
    }
    
}

extension Meme: JSONExportable {
    
    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()
        
        jsonDictionary["id"] = id
        jsonDictionary["date"] = datePosted.dayString
        jsonDictionary["imageURL"] = imageURL.absoluteString
        
        return jsonDictionary
    }
    
}

extension Meme: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let datePostedString = json["date"] as? String else { throw JSONError.keyMismatch("date") }
        guard let datePosted = Date(dateString: datePostedString) else { throw JSONError.typeMismatch("datePosted") }
        guard let imageURLString = json["imageURL"] as? String else { throw JSONError.keyMismatch("imageURLString") }
        guard let imageURL = URL(string: imageURLString) else  { throw JSONError.typeMismatch("imageURL") }
        
        self.id = id
        self.datePosted = datePosted
        self.imageURL = imageURL
    }
    
}
