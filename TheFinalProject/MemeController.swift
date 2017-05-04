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
    let networkController = NetworkController()
    
    var meme: Meme? {
        didSet {
            NotificationCenter.default.post(name: .todaysMemeUpdated, object: meme)
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
                self.generateMemeFromAPI()
            }
        }
    }
    
    func generateMemeFromAPI() {
        guard let generatorsURL = networkController.generatorsURL else { return }
        
        networkController.performRequest(for: generatorsURL, urlParameters: nil) { (json, error) in
            if let json = json, error == nil {
                guard let generatorObjects = json["results"] as? [JSONObject] else {self.meme = nil; return }
                    
            } else {
                self.meme = nil
                print("no Meme")
            }
        }
    }
    
}


