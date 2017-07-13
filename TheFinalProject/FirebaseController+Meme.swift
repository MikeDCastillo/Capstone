//
//  FirebaseController+Meme.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/24/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Firebase

extension FirebaseController {
    
    /// rootRef/users
    var usersRef: DatabaseReference {
        return rootRef.child("users")
    }
    
    /// rootRef/meme
    var memesRef: DatabaseReference {
        return rootRef.child("meme")
    }
    
    /// rootRef/submissions/(memeId)
    func submissionsRef(memeId: String) -> DatabaseReference {
        return rootRef.child("submissions").child(memeId)
    }
    
    /// rootRef/votes/memeId
    func votesRef(memeId: String) -> DatabaseReference {
        return rootRef.child("votes").child(memeId)
    }
    
    ///rootRef/settings
    var settingsRef: DatabaseReference {
        return rootRef.child("settings")
    }
    
    //Storage
    
    /// Avatar Storage URL
    ///
    /// - Parameter userId: id of user
    /// - Returns: reference to folder in DB
    func avatarStorageRef(userId: String) -> StorageReference {
        return storageRef.child(Keys.avatars).child(userId)
    }
 //this is for the second api call
    func uploadedMemeRef(memeName: String) -> StorageReference {
        return storageRef.child(Keys.uploadedMeme).child(memeName)
    }
    
    //FIXME: - make computed property to return a random number in 75
    var memeJpgNumber: String {
        for _ in 1...75 {}
        return "\(1)"
    }
    //TODO: - finsih this function by taking picture and displaying it
    /// second api call to firbase storage to grab jpg data
    ///
    /// - Returns: UIImage
//    func generateRandomMeme() -> UIImage {
//        memesRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            guard let downloadableURL = snapshot.value as? String else { return }
//            let storageRef = Storage.storage().reference(forURL: downloadableURL)
//            storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
//                guard let data = data else { return }
//                guard let memeImage = UIImage(data: data) else { return }
//                
//                picArray.append(memeImage)
//                print("initialized the pic")
//            })
//            self.memesRef.child(self.memeJpgNumber + ".jpg")
//        })
//    }
    
}
