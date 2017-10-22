//
//  Message.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit
import Foundation

struct Message: Identifiable {
    
    var brokerId: String
    var createdAt: Date
    let id: String
    var ownerId: String
    var text: String
    var userId: String
    
    var broker: User? {
        return UserController.shared.users.first(where: { $0.identifier == brokerId })
    }
    var owner: User? {
        return UserController.shared.users.first(where: { $0.identifier == ownerId })
    }
    var client: User? {
        return UserController.shared.users.first(where: { $0.identifier == userId })
    }
    
    init(text: String, brokerId: String, userId: String, ownerId: String) {
        self.text = text
        self.id = UUID().uuidString
        self.brokerId = brokerId
        self.userId = userId
        self.ownerId = ownerId
        self.createdAt = Date()
    }
    
    init?(jsonDictionary: [String: Any]) {
        guard let text = jsonDictionary[Keys.textKey] as? String,
         let brokerId = jsonDictionary[Keys.brokerId] as? String,
            let id = jsonDictionary[Keys.id] as? String,
            let userId = jsonDictionary[Keys.userId] as? String,
            let ownerId = jsonDictionary[Keys.ownerId] as? String,
            let dateNumber = jsonDictionary[Keys.createdAt] as? Double else { return nil }
            
        self.text = text
        self.brokerId = brokerId
        self.id = id
        self.userId = userId
        self.ownerId = ownerId
        self.createdAt = Date(timeIntervalSince1970: dateNumber)
    }
    
}

extension Message: JSONExportable {
    
    func jsonObject() -> [String : Any] {
        var dictionary = [String: Any]()
        
        dictionary[Keys.id] = id
        dictionary[Keys.brokerId] = brokerId
        dictionary[Keys.createdAt] = createdAt.timeIntervalSince1970
        dictionary[Keys.id] = id
        dictionary[Keys.ownerId] = ownerId
        dictionary[Keys.textKey] = text
        
        return dictionary
    }
    
}
