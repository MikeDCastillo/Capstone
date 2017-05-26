//
//  Entry.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Firebase

struct Submission: Identifiable  {
    
    var id: String
    var userId: String
    var topText: String?
    var bottomText: String?
    var textColor: UIColor
    var creationDate: Date
    var voteIds: [String]
    
    var ref: DatabaseReference {
        let meme = MemeController.shared.meme!
        return FirebaseController().submissionsRef(memeId: meme.id).child(id)
    }
}

extension Submission: JSONExportable {
    func json() -> JSONObject {
    
        var jsonDictionary = [String: Any]()
        jsonDictionary["id"] = id
        jsonDictionary["userId"] = userId
        jsonDictionary["topText"] = topText
        jsonDictionary["bottomText"] = bottomText
        jsonDictionary["textColor"] = textColor.hexValue
        jsonDictionary["date"] = creationDate.fullDateString
        jsonDictionary["voteIds"] = voteIds
        
        return jsonDictionary
    }
    
}

extension Submission: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let userId = json["userId"] as? String else { throw JSONError.keyMismatch("userId") }
        guard let textColorString = json["textColor"] as? String,
            let textColor2 = try? UIColor(hex: textColorString) else { throw JSONError.keyMismatch("textColor") }
        guard let creationDateString = json["date"] as? String else { throw JSONError.keyMismatch("date") }
        guard let creationDate = Date(dateString: creationDateString) else { throw JSONError.typeMismatch("creationDate") }
        let voteIds = json["voteIds"] as? [String]
        
        self.id = id
        self.userId = userId
        self.textColor = textColor2
        self.creationDate = creationDate
        self.voteIds = voteIds ?? []
        self.topText = json["topText"] as? String
        self.bottomText = json["bottomText"] as? String
        
    }
    
}

