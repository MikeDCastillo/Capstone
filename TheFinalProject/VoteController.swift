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
    
    func UpVote(like: Vote) {
     
    }
    
    func DownVote() {}
    
    func addWildCardVote() {}
    
}
