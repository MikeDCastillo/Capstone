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
    var imageURLString: String
    var entries: [String]
    var winnerID: String?
    
}

extension Meme: JSONExportable {

    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()
        
        jsonDictionary["id"] = id
        jsonDictionary["date"] = datePosted.fullDateString
        jsonDictionary["imageURLString"] = imageURLString
        jsonDictionary["entries"] = entries
        jsonDictionary["winnerID"] = winnerID
        
        return jsonDictionary
    }
    
}

extension Meme: JSONInitializable {

    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let datePostedString = json["dateposted"] as? String else { throw JSONError.keyMismatch("datePosted") }
        guard let datePosted = Date(dateString: datePostedString) else { throw JSONError.typeMismatch }
        guard let imageURLString = json["imageURLString"] as? String else { throw JSONError.keyMismatch("imageURLString") }
        guard let entries = json["entries"] as? [String] else { throw JSONError.keyMismatch("entries") }
        guard let winnerID = json["winnerID"] as? String else { throw JSONError.keyMismatch("winnerID") }
        
        self.id = id
        self.datePosted = datePosted
        self.imageURLString = imageURLString
        self.entries = entries
        self.winnerID = winnerID
        
    }
    
}
