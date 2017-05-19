//
//  Entry.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

enum TextColor: String {
    
    case white
    case black
    case green
    case blue
    case red
    
    var color: UIColor {
        switch self {
            
        case .white:
            return .white
        case .black:
            return .black
        case .green:
            return .green
        case .blue:
            return .blue
        case .red:
            return .red
        }
    }
    
}

struct Submission /* Hashable */ {
    // var memeId: String
    var id: String
    var userId: String
    var topText: String?
    var bottomText: String?
    var textColor: TextColor
    var creationDate: Date
    var voteIds: [String]
}

extension Submission: JSONExportable {
    func json() -> JSONObject {
    
        var jsonDictionary = [String: Any]()
        jsonDictionary["id"] = id
        jsonDictionary["userId"] = userId
        jsonDictionary["topText"] = topText
        jsonDictionary["bottomText"] = bottomText
        jsonDictionary["textColor"] = textColor
        jsonDictionary["date"] = creationDate
        jsonDictionary["voteIds"] = voteIds
        
        return jsonDictionary
    }
}

extension Submission: JSONInitializable {
    
    init(json: JSONObject) throws {
        guard let id = json["id"] as? String else { throw JSONError.keyMismatch("id") }
        guard let userId = json["userId"] as? String else { throw JSONError.keyMismatch("userId") }
        guard let textColorString = json["textColor"] as? String,
              let textColor2 = TextColor(rawValue: textColorString) else { throw JSONError.keyMismatch("textColor") }
        guard let creationDateString = json["creationDate"] as? String else { throw JSONError.typeMismatch }
        guard let creationDate = Date(dateString: creationDateString) else { throw JSONError.typeMismatch }
        guard let voteIds = json["voteIds"] as? String else { throw JSONError.keyMismatch("voteIds") }
        
        self.id = id
        self.userId = userId
        self.textColor = textColor2
        self.creationDate = creationDate
        self.voteIds = [voteIds]
        self.topText = json["topText"] as? String
        self.bottomText = json["bottomText"] as? String
        
    }
    
}

