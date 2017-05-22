//
//  UserController.swift
//
//
//  Created by Michael Castillo on 3/27/17.
//
//

import UIKit
import FirebaseDatabase

class UserController: Controller {
    
    static let shared = UserController()
    
    var currentUser: User?
    
    var users = Set<User>()
    
}

// MARK: - CRUD Functions


extension UserController {
    
    func createUser(username: String, avatarURLString: String?, completion: ((Error?) -> Void)?) {
        let newUserRef = firebaseController.usersRef.childByAutoId()
        let user = User(id: newUserRef.key, creationDate: Date(), avatarURLString: avatarURLString, username: username)
        
        firebaseController.save(at: newUserRef, json: user.json()) { error in
            completion?(error)
            
            if let error = error {
                print(error.localizedDescription, "\(#line)")
            } else {
                self.currentUser = user
            }
        }
    }
    
    func updateUser(_ user: User) {
        let ref =  firebaseController.usersRef.child(user.id)
        firebaseController.save(at: ref, json: user.json()) { error in
            guard error == nil else { print("error saving user: \(error.debugDescription)"); return }
            self.currentUser = user
        }
    }
    
    func getUser(withId id: String, completion: ((User?) -> Void)?) {
        let ref = firebaseController.usersRef.child(id)
        firebaseController.getData(at: ref) { result in
            switch result {
            case .success(let json):
                let user = try? User(json: json)
                
                if let user = user {
                    self.users.remove(user)
                    self.users.insert(user)
                }
                completion?(user)
            case .failure(let error):
                print("\(error)")
                completion?(nil)
            }
        }
    }
    
    func deleteUser(withId id: String) {
        let ref = firebaseController.usersRef.child(id)
        firebaseController.delete(at: ref) { error in
            if let error = error {
                print("Error deleting user with id: \(id) ERROR: \(error)")
            }
        }
    }
    
}
