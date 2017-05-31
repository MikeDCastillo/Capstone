//
//  VoteController.swift
//  
//
//  Created by Michael Castillo on 3/27/17.
//
//

import Foundation

class VoteController: Controller {
    
    static let shared = VoteController()
    
    var votes = [Vote]() {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name.votesUpdated, object: votes)
        }
    }
    
    func subscribeToVotes(memeId: String) {
        let ref = firebaseController.votesRef(memeId: memeId)
        firebaseController.subscribe(toRef: ref) { (result) in
            switch result {
            case let .success(json):
                var votes = [Vote]()
                json.keys.forEach({ voteIdKey in
                    guard let voteDictionary = json[voteIdKey] as? JSONObject,
                        let vote = try? Vote(json: voteDictionary) else { return }
                    votes.append(vote)
                })
                self.votes = votes
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func createFakeVote(withMemeId id: String) {
        let ref = firebaseController.votesRef(memeId: id)
        firebaseController.save(at: ref, json: ["fake": true], completion: nil)
    }
    
    func vote(_ type: VoteType, on submission: Submission) {
        guard let currentMeme = MemeController.shared.meme else { return }
        let ref = firebaseController.votesRef(memeId: currentMeme.id).childByAutoId()
        guard let currentUser = UserController.shared.currentUser else { return }
        let newVote = Vote(id: ref.key, userId: currentUser.id, type: type, submissionId: submission.id)
        firebaseController.save(at: ref, json: newVote.json()) { error in
            if let error = error {
                dump(error)
            }
        }
    }
    
}


// MARK: - helper func

extension VoteController {

    func votes(for submission: Submission, with type: VoteType? = nil) -> [Vote] {
        if let voteType = type {
            return votes.filter( { $0.submissionId == submission.id && $0.type == voteType })
        } else {
            return votes.filter( { $0.submissionId == submission.id } )
        }
        
    }
}
