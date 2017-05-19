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
    
    let memeController = MemeController.shared
    let layout = UICollectionViewFlowLayout()
    var submissions: [Submission] {
        return SubmissionController.shared.submissions
    }
    
    var todaysMeme: Meme? {
        return MemeController.shared.meme
    }
    
    var users: [User] {
        return UserController.shared.users
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeController.getTodaysMeme()
        
        SubmissionController.shared.submissions = [] // FIXME: Add fake data for testing
        let nibId = String(describing: SubmissionCollectionViewCell.self)
        let nib = UINib(nibName: nibId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibId)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(memeUpdated(_:)), name: NSNotification.Name.init(rawValue: "memeUpdated"), object: nil)
    }
    
    func memeUpdated(_ notification: NSNotification) {
        guard let todaysMeme = todaysMeme else { return }
        imageView.kf.setImage(with: todaysMeme.imageURL)
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
        guard let user = users.first(where: { $0.id == submission.userId }) else { return cell }
        cell.update(with: submission, user: user)
        return cell
    }

}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
