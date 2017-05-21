//
//  NewSubmissionViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/20/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher

class NewSubmissionViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    fileprivate var meme: Meme? {
        return MemeController.shared.meme
    }
    fileprivate let submissionController = SubmissionController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        guard let meme = meme else { return }
            imageView.kf.setImage(with: meme.imageURL)
        guard let currentUser = UserController.shared.currentUser else { return }
        let newSubmission = Submission(id: "", userId: currentUser.id, topText: "Hey", bottomText: "You", textColor: TextColor.black, creationDate: Date(), voteIds: [])
        submissionController.saveSubmission(newSubmission, memeId: meme.id)
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}
