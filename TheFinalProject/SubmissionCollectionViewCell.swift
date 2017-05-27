//
//  SubmissionCollectionViewCell.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/3/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher

class SubmissionCollectionViewCell: UICollectionViewCell, AutoClassNameable {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var upVote: UILabel!
    @IBOutlet weak var downVote: UILabel!
    @IBOutlet weak var randomVote: UILabel!
    
    
    func update(with submission: Submission, user: User?/*, votes: [Vote]*/) {
        topLabel.text = submission.topText
        bottomLabel.text = submission.bottomText
        topLabel.textColor = submission.textColor
        bottomLabel.textColor = submission.textColor
        avatarImageView.kf.setImage(with: user?.avatarURL, placeholder: #imageLiteral(resourceName: "meMeme0"))
        userNameLabel.text = user?.username ?? "--"
        dateLabel.text = submission.creationDate.timeSince
        //vote labels here
    }
    
}
