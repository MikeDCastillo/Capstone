//
//  DatabaseManager.swift
//  5StarAutoDirect
//
//  Created by Alex Whitlock on 6/29/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation
import Firebase
import KeychainSwift

class DatabaseManager {
    
    static private let firebaseController = FirebaseController()
    static private let keyChain = KeychainSwift()
    
    static var uid: String? {
        get {
            return keyChain.get(Keys.uid)
        }
        set {
            guard let newValue = newValue else { return }
            keyChain.set(newValue, forKey: Keys.uid)
        }
    }
    
}
