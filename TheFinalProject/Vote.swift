//
//  Vote.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit


struct Vote {
    var id: String
    var userId: String
    var type: String?
    
    
    init(id: String, userId: String, type: String? = nil) {
        self.id = id
        self.userId = userId
    }
}


// MARK: - Black diamond
// FIXME: - what to do with this enum
extension Vote {

    enum VoteType: String {
    case lol
    case wtf
    case dislike
    }

}

extension Vote: JSONInitializable {

    init(json: JSONObject) throws {
      
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let userId = json["userId"] as? String else { throw JSONError.keyMismatch("userId") }
        guard let type = json["type"] as? String else { throw JSONError.keyMismatch("type") }
        
        self.id = id
        self.userId = userId
        self.type = type
    }
    
}

extension Vote: JSONExportable {

    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()

        jsonDictionary["id"] = id
        jsonDictionary["userID"] = userId
        jsonDictionary["type"] = type
        
        return jsonDictionary
    }
}
