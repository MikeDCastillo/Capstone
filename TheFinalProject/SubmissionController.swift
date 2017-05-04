//
//  SubmissionController.swift
//  
//
//  Created by Michael Castillo on 3/27/17.
//
//

import UIKit

class SubmissionController: Controller {

    static let shared = SubmissionController()
    
    var submissions = [Submission](){
        didSet {
            NotificationCenter.default.post(name: .submissionUpdated, object: nil)
        }
    }
    
    
    func createFakeSubmission(withMemeId id: String) {
        let memeId = firebaseController.submissionsRef(memeId: id).description()
        
    }
    
    func saveSubmission(_ submission: Submission) {
        
    }
    
    func subscribeToSubmissions(forMemeId id: String) {
    let ref = firebaseController.submissionsRef(memeId: id)
        firebaseController.subscribe(toRef: ref) { (result) in
            switch result {
                case .success(let json):
                    var tempSubmissionsArray = [Submission]()
                    json.keys.forEach({ (key) in
                        guard let submissionDictionary = json[key] as? JSONObject else { return }
                        guard let newSubmission = try? Submission(json: submissionDictionary) else { return }
                        tempSubmissionsArray.append(newSubmission)
                    })
                self.submissions = tempSubmissionsArray
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func deleteSubmission() {}
    
    func reportSubmission() {}
}
