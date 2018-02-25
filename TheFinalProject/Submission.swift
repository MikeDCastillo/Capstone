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
    var memeId: String
    var topText: String?
    var bottomText: String?
    var textColor: UIColor
    var creationDate: Date
    var flagCount: Int

    var hasBeenReported: Bool {
        return flagCount > 0
    }
    
    var ref: DatabaseReference {
        let meme = MemeController.shared.meme!
        return FirebaseController().submissionsRef(memeId: meme.id).child(id)
    }
    
    init(id: String = UUID().uuidString, userId: String, memeId: String, topText: String?, bottomText: String?, textColor: UIColor) {
        self.id = id
        self.userId = userId
        self.memeId = memeId
        self.topText = topText
        self.bottomText = bottomText
        self.textColor = textColor
        self.creationDate = Date()
        self.flagCount = 0
    }
    
}


// MARK: - JSONExportable

extension Submission: JSONExportable {
    
    func json() -> JSONObject {
        var jsonDictionary = [String: Any]()
        jsonDictionary["id"] = id
        jsonDictionary["userId"] = userId
        jsonDictionary["memeId"] = memeId
        jsonDictionary["topText"] = topText
        jsonDictionary["bottomText"] = bottomText
        jsonDictionary["textColor"] = textColor.hexValue
        jsonDictionary["date"] = creationDate.timeIntervalSinceReferenceDate
        jsonDictionary["flagCount"] = flagCount
        
        return jsonDictionary
    }
    
}


// MARK: - JSONInit

extension Submission: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let userId = json["userId"] as? String else { throw JSONError.keyMismatch("userId") }
        guard let memeId = json["memeId"] as? String else { throw
            JSONError.keyMismatch("memeId") }
        let topText = json["topText"] as? String
        let bottomText = json["bottomText"] as? String
        
        guard let textColorString = json["textColor"] as? String,
            let textColor2 = try? UIColor(hex: textColorString) else { throw JSONError.keyMismatch("textColor") }
        guard let creationDateNumber = json["date"] as? Double else { throw JSONError.keyMismatch("date") }
        let creationDate = Date(timeIntervalSinceReferenceDate: creationDateNumber)
        guard let flagCount = json["flagCount"] as? Int else { throw JSONError.typeMismatch("flagCount") }
        
        self.id = id
        self.userId = userId
        self.memeId = memeId
        self.textColor = textColor2
        self.creationDate = creationDate
        self.topText = topText
        self.bottomText = bottomText
        self.flagCount = flagCount
    }
    
}
