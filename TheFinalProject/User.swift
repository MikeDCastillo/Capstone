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
    var username: String?

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
        jsonDictionary[Keys.id] = id
        jsonDictionary[Keys.creationDate] = creationDate.timeIntervalSinceReferenceDate
        jsonDictionary[Keys.avatarURLString] = avatarURLString
        jsonDictionary[Keys.username] = username
        
        return jsonDictionary
    }
}

extension User: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json[Keys.id] as? String else { throw JSONError.keyMismatch(Keys.id) }
        guard let creationDateDouble = json[Keys.creationDate] as? Double else { throw JSONError.keyMismatch(Keys.creationDate) }
        let creationDate = Date(timeIntervalSinceReferenceDate: creationDateDouble)
        let avatarString = json[Keys.avatarURLString] as? String
        let username = json[Keys.username] as? String
        
        self.id = id
        self.avatarURLString = avatarString
        self.creationDate = creationDate
        self.username = username
    }
    
}
