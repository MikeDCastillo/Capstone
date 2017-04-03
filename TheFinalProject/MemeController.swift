//
//  MemeController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/27/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Firebase

class MemeController: Controller {
    
    static let shared = MemeController()
    
    var meme: Meme? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("memeUpdated"), object: meme)
        }
    }
    
    func createMeme() {
        MemeAPIAccess.getNewMemeURL { (url) in
            if let url = url {
                let ref = firebaseController.memesRef.childByAutoId()
            let newMeme = Meme(id: ref.key, imageURL: url)
                firebaseController.save(at: ref, json: newMeme.json(), completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                        } else {
                            self.subscribeToMeme(newMeme.id)
                    }
                })
            }
        }
    }
    
    func subscribeToMeme(_ memeID: String) {
        let ref = firebaseController.memesRef.child(memeID)
        ref.observe(.value, with: { snap in
            if let snapJSON = snap.value as? JSONObject, let meme = try? Meme(json: snapJSON) {
                self.meme = meme
            } else {
                print("error subscribing to daily meme")
            }
        })
    }
    
    func getAllMemes(forDate date: Date = Date(), completion: (Meme?) -> Void) {
    }
    
    func getTodaysMeme() {
        
        let todayString = Date().dayString
        let query = firebaseController.memesRef.queryOrdered(byChild: "date").queryEqual(toValue: todayString)
        firebaseController.getData(with: query) { (result) in
            if case let .success(json) = result, let memeID = json.keys.first {
                self.subscribeToMeme(memeID)
            } else {
                self.createMeme()
            }
        }
    }
    
}

extension NSNotification.Name {
    
}
