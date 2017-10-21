//
//  UserController.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Firebase
import Foundation

class UserController {
    
    static let shared = UserController()
    
    let firebaseController = FirebaseController()
    var currentUser: User?
    var isSubscribedToUsers = false
    var rootRef = Database.database().reference()
    var users = [User]() {
        didSet {
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
        firebaseController.save(at: ref, json: user.jsonObject()) { (error) in
            if let error = error {
                print(error.localizedDescription, "\(#line) in \(#file)")
                //TODO: - Alert controller
            } else {
                self.currentUser = user
                print("success updating User \(#line)")
            }
        }
    }
    
    enum UserControllerError: Error {
        case uidNil // FIXME:
    }
    
    //Model objects into jsonExportable
    func saveUserToFirebase(name: String, phone: String, email: String, password: String, completion: @escaping(_ isBroker: Bool?, Error?) -> Void) {
        
        let isBroker = email.uppercased().contains("FIVESTARAUTODIRECT")
        let refString = isBroker ? "brokers" : "users"
        
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
            
            let referenceForCurrentUser = self.rootRef.child(refString).child(uidString)
            //            referenceForCurrentUser.setValue(user.jsonRepresentation)
            referenceForCurrentUser.setValue(user.jsonObject(), withCompletionBlock: { (error, ref) in
                DatabaseManager.uid = uidString
                self.currentUser = user
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
    func fetchUsers() {
        guard !isSubscribedToUsers else { return }
        isSubscribedToUsers = true
        let usersRef: DatabaseReference = rootRef.child("users")
        
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
    
    //Use to get currentUser
    
    func getCurrentUser() {
        guard let currentAuthUser = Auth.auth().currentUser else { return }
        let ref = firebaseController.usersRef.child(currentAuthUser.uid)
        firebaseController.getData(at: ref) { (result) in
            let userResult = result.map(User.init)
            switch userResult {
            case .failure:
                break
            case .success(let user):
                self.currentUser = user
                if user == nil {
                    print("trouble getting current user")
                }
            }
        }
        
    }
    
}

protocol UserControllerDelegate: class {
    func usersWereUpdatedTo(users: [User])
}
