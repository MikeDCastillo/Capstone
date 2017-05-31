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
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBOutlet weak var wtfLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        
    }
    
    func update(with submission: Submission, user: User?, votes: [Vote]) {
        topLabel.text = submission.topText
        bottomLabel.text = submission.bottomText
        topLabel.textColor = submission.textColor
        bottomLabel.textColor = submission.textColor
        avatarImageView.kf.setImage(with: user?.avatarURL, placeholder: #imageLiteral(resourceName: "user"))
        userNameLabel.text = user?.username ?? "--"
        dateLabel.text = submission.creationDate.timeSince
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        likesLabel.text = "\(votes.ofType(.like).count)"
        dislikesLabel.text = "\(votes.ofType(.dislike).count)"
        wtfLabel.text = "\(votes.ofType(.wtf).count)"
    }
  
    
}
