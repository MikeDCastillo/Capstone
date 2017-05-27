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
        firebaseController.subscribe(toRef: ref) { result in
            switch result {
            case let .success(json):
                if let meme = try? Meme(json: json) {
                    self.meme = meme
                    
                } else {
                    print("error subscribing to daily meme")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getAllMemes(forDate date: Date = Date(), completion: (Meme?) -> Void) {
    }
    
    func getTodaysMeme() {
        let todayString = Date().dayString
        let query = firebaseController.memesRef.queryOrdered(byChild: "date").queryEqual(toValue: todayString)
        firebaseController.getData(with: query) { (result) in
            if case let .success(json) = result, let memeID = json.keys.first {
                self.subscribeToMeme(memeID)
                SubmissionController.shared.subscribeToSubmissions(forMemeId: memeID)
            } else {
                self.generateMemeFromAPI()
            }
        }
    }
    
    func generateMemeFromAPI() {
        guard let generatorsURL = networkController.generatorsURL else { return }
        
        networkController.performRequest(for: generatorsURL, urlParameters: nil) { (json, error) in
            if let json = json, error == nil {
                guard let generatorObjects = json["result"] as? [JSONObject] else {self.meme = nil; return }
                let generators = generatorObjects.flatMap { try? Generator(json: $0) }
                let randomIndex = Int(arc4random_uniform(UInt32(generators.count - 1)))
                let selectedGenerator = generators[randomIndex]
                self.saveMeme(from: selectedGenerator)
            } else {
                self.meme = nil
                dump(error)
                print("no Meme")
            }
        }
    }
    
    func saveMeme(from generator: Generator) {
        guard let generatorURL = generator.imageURL else { return }
        let ref = firebaseController.memesRef.childByAutoId()
        let newMeme = Meme(id: ref.key, imageURL: generatorURL)
        firebaseController.save(at: ref, json: newMeme.json(), completion: { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                self.subscribeToMeme(newMeme.id)
                SubmissionController.shared.createFakeSubmission(withMemeId: newMeme.id, completion: { error in
                    if error == nil {
                        SubmissionController.shared.subscribeToSubmissions(forMemeId: newMeme.id)
                    }
                })
            }
        })
    }
    
}


