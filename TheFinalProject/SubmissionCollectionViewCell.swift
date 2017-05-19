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
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func update(with submission: Submission, user: User) {
        topLabel.text = submission.topText
        bottomLabel.text = submission.bottomText
        topLabel.textColor = submission.textColor.color
        bottomLabel.textColor = submission.textColor.color
        avatarImageView.kf.setImage(with: user.avatarURL)
        userNameLabel.text = user.username
        dateImageView.image = nil //FIXME: - give me label
        dateLabel.text = submission.creationDate.dayString //FIXME: - pretty date string
    }
    
}
