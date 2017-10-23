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
    
    var createdAt: Date
    let id: String
    var ownerId: String
    var text: String
    var customerId: String
    
    var owner: User? {
        return UserController.shared.users.first(where: { $0.identifier == ownerId })
    }
    var client: User? {
        return UserController.shared.users.first(where: { $0.identifier == customerId })
    }
    
    init(id: String = UUID().uuidString, text: String, customerId: String, ownerId: String) {
        self.text = text
        self.id = id
        self.customerId = customerId
        self.ownerId = ownerId
        self.createdAt = Date()
    }
    
    init?(jsonDictionary: [String: Any]) {
        guard let text = jsonDictionary[Keys.textKey] as? String,
            let id = jsonDictionary[Keys.id] as? String,
            let customerId = jsonDictionary[Keys.customerId] as? String,
            let ownerId = jsonDictionary[Keys.ownerId] as? String,
            let dateNumber = jsonDictionary[Keys.createdAt] as? Double else { return nil }
            
        self.text = text
        self.id = id
        self.customerId = customerId
        self.ownerId = ownerId
        self.createdAt = Date(timeIntervalSince1970: dateNumber)
    }
    
}

extension Message: JSONExportable {
    
    func jsonObject() -> JSONObject {
        var dictionary = JSONObject()
        dictionary[Keys.id] = id
        dictionary[Keys.createdAt] = createdAt.timeIntervalSince1970
        dictionary[Keys.id] = id
        dictionary[Keys.ownerId] = ownerId
        dictionary[Keys.textKey] = text
        dictionary[Keys.customerId] = customerId
        
        return dictionary
    }
    
}
