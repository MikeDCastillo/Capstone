//
//  SubmissionController.swift
//  
//
//  Created by Michael Castillo on 3/27/17.
//
//

import UIKit

struct SubmissionController: Controller {

    static let shared = SubmissionController()
    
    var submissions = Set<Submission>()
    
    func submissions(forMeme meme: Meme) {
        return submissions.filter { $0.memeId == meme.id }
    }
    
    let submissionForMeme = SubmissionController.shared.submissions[memeId]
    func saveSubmission() {}
    
    func loadSubmission() {}
    
    func deleteSubmission() {}
    
    func reportSubmission() {}
}
