//
//  User.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

struct User {
    
    var id: String
    var creationDate: Date
    var avatarURLString: String?
    var username: String

    var avatarURL: URL? {
        guard let urlString = avatarURLString else { return nil }
        return URL(string: urlString)
    }
    
}

extension User: JSONExportable {
    
    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()
        jsonDictionary["id"] = id
        jsonDictionary["creationDate"] = creationDate.dayString
        jsonDictionary["avatarURLString"] = avatarURLString
        jsonDictionary["username"] = username
        
        return jsonDictionary
    }
}

extension User: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let creationDateString = json["creationDate"] as? String else { throw JSONError.keyMismatch("creationDate") }
        guard let creationDate = Date(dateString: creationDateString) else { throw JSONError.typeMismatch }
        guard let username = json["username"] as? String else { throw JSONError.keyMismatch("username") }
        
        
        self.id = id
        self.avatarURLString = json["avatarURLString"] as? String
        self.creationDate = creationDate
        self.username = username
    }
    
}
