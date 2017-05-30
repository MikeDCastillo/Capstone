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
    
    func avatarStorageRef(userId: String) -> StorageReference {
        return storageRef.child(Keys.avatars).child(userId)
    }
    
}
