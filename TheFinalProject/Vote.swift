//
//  Vote.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

enum VoteType: String {
    case like
    case dislike
    case wtf
}

struct Vote {
    var id: String
    var userId: String
    var type: VoteType
    var submissionId: String
    
    init(id: String, userId: String, type: VoteType, submissionId: String) {
        self.id = id
        self.userId = userId
        self.type = type
        self.submissionId = submissionId
    }
}

extension Vote: JSONInitializable {

    init(json: JSONObject) throws {
      
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let userId = json["userId"] as? String else { throw JSONError.keyMismatch("userId") }
        guard let type = json["type"] as? String else { throw JSONError.keyMismatch("type") }
        guard let voteType = VoteType(rawValue: type) else { throw JSONError.typeMismatch("type") }
        guard let submissionId = json["submissionId"] as? String else { throw JSONError.keyMismatch("submissionId") }
        
        self.id = id
        self.userId = userId
        self.type = voteType
        self.submissionId = submissionId
    }
    
}

extension Vote: JSONExportable {

    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()

        jsonDictionary["id"] = id
        jsonDictionary["userID"] = userId
        jsonDictionary["type"] = type
        jsonDictionary["submissionId"] = submissionId
        
        return jsonDictionary
    }
}
