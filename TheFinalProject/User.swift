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

extension User: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}

extension User: JSONExportable {
    
    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()
        jsonDictionary["id"] = id
        jsonDictionary["creationDate"] = creationDate.timeIntervalSinceReferenceDate
        jsonDictionary["avatarURLString"] = avatarURLString
        jsonDictionary["username"] = username
        
        return jsonDictionary
    }
}

extension User: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let creationDateDouble = json["creationDate"] as? Double else { throw JSONError.keyMismatch("creationDate") }
        let creationDate = Date(timeIntervalSinceReferenceDate: creationDateDouble)
        guard let username = json["username"] as? String else { throw JSONError.keyMismatch("username") }
        
        self.id = id
        self.avatarURLString = json["avatarURLString"] as? String
        self.creationDate = creationDate
        self.username = username
    }
    
}
