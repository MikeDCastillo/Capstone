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
    
    fileprivate let userController = UserController.shared
    
    var submissions = [Submission](){
        didSet {
            NotificationCenter.default.post(name: .submissionUpdated, object: nil)
            fetchUsers(from: submissions)
        }
    }
    
    func createFakeSubmission(withMemeId id: String) {
        let ref = firebaseController.submissionsRef(memeId: id)
        firebaseController.save(at: ref, json: ["fake": true], completion: nil)
    }
    
    func saveSubmission(_ submission: Submission, memeId: String) {
        var ref = firebaseController.submissionsRef(memeId: memeId)
        var updatedSubmission = submission
        if submission.id.isEmpty {
            ref = ref.childByAutoId()
            updatedSubmission.id = ref.key
        } else {
            ref = ref.child(submission.id)
        }
        firebaseController.save(at: ref, json: updatedSubmission.json()) { error in
            if let error = error {
                print(error)
            }
        }
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
                self.submissions = tempSubmissionsArray.sorted(by: { $0.creationDate > $1.creationDate })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUsers(from submissions: [Submission]) {
        submissions.forEach { submission in
            let user = userController.users.first(where: { $0.id == submission.userId })
            
            if let _ = user {
                return
            } else {
                userController.getUser(withId: submission.userId, completion: nil)
            }
        }
    }
    
    func deleteSubmission() {}
    
    func reportSubmission() {}
}
