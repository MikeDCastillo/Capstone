//
//  ViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/2/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher

class FeedViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var voteButton: UIButton!
    
    let memeController = MemeController.shared
    let layout = UICollectionViewFlowLayout()

    
    var submissions: [Submission] {
        return SubmissionController.shared.submissions
    }
    var todaysMeme: Meme? {
        return MemeController.shared.meme
    }
    var users: [User] {
        return Array(UserController.shared.users)
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        memeController.getTodaysMeme()
        
        let fakeUser = User(id: "mj", creationDate: Date(), avatarURLString: nil, username: "michael")
        UserController.shared.currentUser = fakeUser
        
        let nibId = String(describing: SubmissionCollectionViewCell.self)
        let nib = UINib(nibName: nibId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibId)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        setupVoteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(memeUpdated(_:)), name: NSNotification.Name.todaysMemeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submissionsUpdated(_:)), name: NSNotification.Name.submissionUpdated, object: nil)
    }
    
    // MARK: - Actions

    @IBAction func voteButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            let angle = CGFloat(180 * Double.pi / 180)
            self.voteButton.transform = CGAffineTransform(rotationAngle: angle)
            let alert = UIAlertController(title: "You Voted", message: "Come back later", preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "bye", style: .cancel)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
            self.voteButton.alpha = 0
            //call vote function here
        }
    }
    
    func memeUpdated(_ notification: NSNotification) {
        guard let todaysMeme = todaysMeme else { return }
        imageView.kf.setImage(with: todaysMeme.imageURL)
    }
    
    func submissionsUpdated(_ notification: NSNotification) {
        collectionView.reloadData()
    }
    
}


// MARK: - Data Source Methods

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmissionCollectionViewCell.className, for: indexPath) as! SubmissionCollectionViewCell
        let submission = submissions[indexPath.row]
        let user = users.first(where: { $0.id == submission.userId })
        cell.update(with: submission, user: user)
        return cell
    }

}


// MARK: - setup collectionView

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}


// MARK: - Setup Button

extension FeedViewController {

    func setupVoteButton() {
        voteButton.layer.cornerRadius = 6
    }
    
}
