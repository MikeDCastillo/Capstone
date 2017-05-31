//
//  SortType.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

enum SortType: Int {
    case likes
    case recent
    
    var title: String {
        switch self {
        case .likes:
            return "Most Likes"
        case .recent:
            return "Most Recent"
        }
    }
    
    var sort: ((Submission, Submission) -> Bool) {
        switch self {
        case .likes:
            return { (first, second) -> Bool in
                let firstLikes = VoteController.shared.votes(for: first, with: VoteType.like)
                let secondLikes = VoteController.shared.votes(for: second, with: .like)
                return firstLikes.count > secondLikes.count
            }
        case .recent:
            return { $0.creationDate >  $1.creationDate }
        }
    }
    
}
