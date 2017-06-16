//
//  UserController.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation

struct UserController {
    
    static var shared = UserController()
    
    var users: [User] = []
    var brokers: [User] = [] // if they're a broker, append here
    
    mutating func createUser(name: String, phone: String, email: String, isBroker: Bool) {
        // checking to see if email contains 5starAuto, if so, isBroker is true
        
        let user = User(name: name, phone: phone, email: email, isBroker: isBroker, messages: [])
        users.insert(user, at: 0)
    }
    
    func deleteUser() {
        
    }
}
