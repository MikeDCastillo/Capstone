//
//  UserController.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let shared = UserController()
    
    let firebaseController = FirebaseController()
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    var currentUser: User? {
        guard let id = currentUserId else { return nil }
        return users.first(where: { $0.identifier == id })
    }
    var selectedUserId: String?
    var selectedUser: User? {
        guard let id = selectedUserId else { return nil }
        return users.first(where: { $0.identifier == id })
    }
    var isSubscribedToUsers = false
    var users = [User]() {
        didSet {
            if let currentUser = currentUser {
                MessageController.shared.loadInitialMessages()
                if !currentUser.isBroker {
                    selectedUserId = currentUserId
                }
                
            }
            NotificationCenter.default.post(name: .usersLoaded, object: nil)
        }
    }
    
    weak var delegate: UserControllerDelegate?
    
    func saveCarToUser(car: Car, completion: ((User?) -> Void)?) {
        guard let currentUser = currentUser else { return }
        currentUser.car = car
        updateUser(user: currentUser)
    }
    
    func updateUser(user: User) {
        let ref = firebaseController.usersRef.child(user.identifier)
        firebaseController.save(at: ref, json: user.jsonObject(), completion: nil)
    }
    
    enum UserControllerError: Error {
        case uidNil // FIXME:
    }
    
    //Model objects into jsonExportable
    func saveUserToFirebase(name: String, phone: String, email: String, password: String, completion: @escaping(_ isBroker: Bool?, Error?) -> Void) {
        let isBroker = email.uppercased().contains("FIVESTARAUTODIRECT")
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            guard let uidString = user?.uid
                else { completion(nil, UserControllerError.uidNil); return }
            
            let user = User(name: name, phone: phone, email: email, isBroker: isBroker, identifier: uidString)
            
            // Put authenticated user in firebase database under appropriate node.
            
            let referenceForCurrentUser = self.firebaseController.usersRef.child(uidString)
            referenceForCurrentUser.setValue(user.jsonObject(), withCompletionBlock: { (error, ref) in
                completion(isBroker, nil)
            })
            
            
            
            //// DO NOT DELETE might need this for the login screen, only Clay can delete this
            //            if !(email.contains(".")) {
            //                self.badEmail()
            //            } else if !(user.email?.contains("@"))! {
            //                self.badEmail()
            //            }
            //            if (user.phone?.characters.count)! < 10 {
            //                self.badPhoneNumberAC()
            //            }
            //            if password == "" {
            //                self.badPasswordAC()
            //            }
            //            if name == "" {
            //                self.badNameAC()
            //            }
            
        })
    }
    
    // getting users from firebase
    func subscribeToUsers() {
        guard !isSubscribedToUsers else { return }
        isSubscribedToUsers = true
        let usersRef: DatabaseReference = firebaseController.usersRef
        
        firebaseController.subscribe(toRef: usersRef) { (result) in
            let usersResult = result.map({ (json) -> [User] in
                var userArray = [User]()
                json.forEach({ (key, value) in
                    guard var valueJSON = value as? JSONObject else { return }
                    valueJSON[Keys.id] = key
                    guard let newUser = User(jsonDictionary: valueJSON) else { return }
                    userArray.append(newUser)
                })
                return userArray
            })
            switch usersResult {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

protocol UserControllerDelegate: class {
    func usersWereUpdatedTo(users: [User])
}
