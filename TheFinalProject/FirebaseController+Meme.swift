//
//  FirebaseController+Meme.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/24/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
    
}
