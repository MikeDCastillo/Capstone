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
    var usersRef: FIRDatabaseReference {
        return rootRef.child("users")
    }
    
    /// rootRef/dailyMeme
    var dailyMemesRef: FIRDatabaseReference {
        return rootRef.child("dailyMemesRef")
    }
    
    /// rootRef/submissions
    func submissionsRef(memeId: String) -> FIRDatabaseReference {
        return rootRef.child("submissions").child(memeId)
    }
    
    /// rootRef/votes
    func votesRef(submissionId: String) -> FIRDatabaseReference {
        return rootRef.child("votes").child(submissionId)
    }
    
}
