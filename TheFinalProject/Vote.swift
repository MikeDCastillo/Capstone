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
        guard let id = json[Keys.id] as? String else { throw JSONError.keyMismatch(Keys.id) }
        guard let userId = json[Keys.userId] as? String else { throw JSONError.keyMismatch(Keys.userId) }
        guard let type = json[Keys.type] as? String else { throw JSONError.keyMismatch(Keys.type) }
        guard let voteType = VoteType(rawValue: type) else { throw JSONError.typeMismatch(Keys.type) }
        guard let submissionId = json[Keys.submissionId] as? String else { throw JSONError.keyMismatch(Keys.submissionId) }
        
        self.id = id
        self.userId = userId
        self.type = voteType
        self.submissionId = submissionId
    }
    
}

extension Vote: JSONExportable {

    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()

        jsonDictionary[Keys.id] = id
        jsonDictionary[Keys.userId] = userId
        jsonDictionary[Keys.type] = type.rawValue
        jsonDictionary[Keys.submissionId] = submissionId
        
        return jsonDictionary
    }
    
}

extension Array where Iterator.Element == Vote {

    func ofType(_ type: VoteType) -> [Vote] {
       return self.filter { $0.type == type }
    }
    
}
