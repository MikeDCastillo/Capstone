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
    
    var vote: Vote? {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name("voteUpdated"), object: vote)
        }
    }
    
    func UpVote(lol: Vote) {
        //FIXME: - finsih this function
        let lol = Vote.VoteType.lol
        
//        firebaseController.save(at: <#T##FIRDatabaseReference#>, json: <#T##JSONObject#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    func DownVote() {}
    
    func addWildCardVote() {}
    
}
