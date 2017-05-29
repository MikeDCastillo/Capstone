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
    
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.userUpdated, object: nil)
        }
    }
    var users = Set<User>()
}

// MARK: - CRUD Functions


extension UserController {
    
    func loadCurrentUser(completion: @escaping (User?, String?) -> Void)  {
        CloudKitManager.getUseriCloudId { iCloudId in
            guard let iCloudId = iCloudId else { completion(nil, nil); return }
            
            let ref = self.firebaseController.usersRef.child(iCloudId)
            self.firebaseController.getData(at: ref) { (result) in
                switch result {
                case .success(let json):
                    let user = try? User(json: json)
                    completion(user, iCloudId)
                    
                    if let currentUser = user {
                        self.currentUser = currentUser
                    }
                case .failure(let error):
                    print("\(error)")
                    completion(nil, iCloudId)
                }
            }
        }
    }
    
    func createUser(iCloudId: String, username: String, avatarURLString: String? = nil, completion: ((Error?) -> Void)?) {
        let newUserRef = firebaseController.usersRef.child(iCloudId)
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
    
    func saveAvatar(image: UIImage) {
        guard let data = UIImageJPEGRepresentation(image, 0.6) else { print("\(#line)"); return }
        guard let currrentUser = currentUser else { return }
        let ref = firebaseController.avatarStorageRef(userId: currrentUser.id)
        firebaseController.upload(data, ref: ref) { (result) in
            switch result {
            case let .success(avatarURL):
                var updatedUser = currrentUser
                updatedUser.avatarURLString = avatarURL.absoluteString
                self.updateUser(updatedUser)
            case let .failure(error):
                print("\(error)")
            }
        }
    }
    
}
