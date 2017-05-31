//
//  ViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/2/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds

class FeedViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var wtfButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var originalVoteConstraints: [NSLayoutConstraint]!
    
    fileprivate var likeButtonCenter: CGPoint!
    fileprivate var dislikeButtonCenter: CGPoint!
    fileprivate var wtfButtonCenter: CGPoint!
    fileprivate let userController = UserController.shared
    fileprivate let memeController = MemeController.shared
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate let iCloudSegue = "iCloudSegue"
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // sort array by most likes
            //            SortType.likes.sort(submission, submission)
            print("foo")
            
        case 1:
            // sort array by most recent Date
            //            SortType.recent.sort(<#T##Submission#>, <#T##Submission#>)
            print("bar")
        default:
            break
        }
    }
    
    fileprivate var submissions: [Submission] {
        return SubmissionController.shared.submissions
    }
    fileprivate var todaysMeme: Meme? {
        return MemeController.shared.meme
    }
    fileprivate var users: [User] {
        return Array(UserController.shared.users)
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeController.getTodaysMeme()
        setUpCollectionView()
        setupUIButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(memeUpdated(_:)), name: NSNotification.Name.todaysMemeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submissionsUpdated(_:)), name: NSNotification.Name.submissionUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(votesUpdated(_:)), name: NSNotification.Name.votesUpdated, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func voteButtonTapped(_ sender: UIButton) {
        dump(likeButton.center)
        dump(dislikeButton.center)
        dump(wtfButton.center)
        
        originalVoteConstraints.forEach { constraint in
            constraint.isActive = true
        }

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
            self.voteButton.isHidden = true
            self.likeButton.alpha = 1
            self.dislikeButton.alpha = 1
            self.wtfButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let currentSubmission = currentSubmission() else { return }
        VoteController.shared.vote(.like, on: currentSubmission)
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        guard let currentSubmission = currentSubmission() else { return }
        VoteController.shared.vote(.dislike, on: currentSubmission)
    }
    
    @IBAction func wtfButtonTapped(_ sender: UIButton) {
        guard let currentSubmission = currentSubmission() else { return }
        VoteController.shared.vote(.wtf, on: currentSubmission)
    }
    
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
        let previous = sender == previousButton
        moveCell(previous: previous)
    }
    
    func memeUpdated(_ notification: NSNotification) {
        guard let todaysMeme = todaysMeme else { return }
        imageView.kf.setImage(with: todaysMeme.imageURL)
    }
    
    func submissionsUpdated(_ notification: NSNotification) {
        collectionView.reloadData()
    }
    
    func votesUpdated(_ notification: NSNotification) {
        collectionView.reloadData()
    }

}


// MARK: - Fileprivate

extension FeedViewController {
    
    fileprivate func setUpCollectionView() {
        let nibId = String(describing: SubmissionCollectionViewCell.self)
        let nib = UINib(nibName: nibId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibId)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    fileprivate func setupUIButtons() {
        // To cache CG point postions of UI Buttons
        likeButtonCenter = likeButton.center
        dislikeButtonCenter = dislikeButton.center
        wtfButtonCenter = wtfButton.center
        
        originalVoteConstraints.forEach { constraint in
            constraint.isActive = false
        }
        //setting the initail GGPoint of buttons under the vote button. then setting the CGPoints where they live when pulled back under the vote button
        likeButton.center = voteButton.center
        dislikeButton.center = voteButton.center
        wtfButton.center = voteButton.center
        voteButton.layer.cornerRadius = 5
    }
    
    func setUpAds() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    fileprivate func loadCurrentUser() {
        userController.loadCurrentUser { user, iCloudId in
            if let _ = user {
                return // User was loaded successfully and all is right in the world
            } else if let iCloudId = iCloudId {
                self.createUser(with: iCloudId)
                //FIXME: - Show onboarding experience
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.performSegue(withIdentifier: self.iCloudSegue, sender: self)
                })
            }
        }
    }
    
    fileprivate func createUser(with iCloudId: String) {
        self.userController.createUser(iCloudId: iCloudId, username: nil, completion: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    fileprivate func currentSubmission() -> Submission? {
        guard let indexPath = collectionView.indexPathForItem(at: collectionView.center) else  { return nil }
        return submissions[indexPath.item]
    }
    
    fileprivate func moveCell(previous: Bool) {
        guard submissions.count > 1 else { return }
        guard let indexPathAtCenter = collectionView.centerCellIndexPath else { return }

        if previous {
            guard indexPathAtCenter.item > 0 else { return }
            let indexPathToScroll = IndexPath(item: indexPathAtCenter.item - 1, section: 0)
            collectionView.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
        } else {
            guard indexPathAtCenter.item < submissions.count - 1 else { return }
            let indexPathToScroll = IndexPath(item: indexPathAtCenter.item + 1, section: 0)
            collectionView.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
        }
    }
    
}


// MARK: - Data Source Methods

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmissionCollectionViewCell.className, for: indexPath) as! SubmissionCollectionViewCell
        let submission = submissions[indexPath.item]
        let user = users.first(where: { $0.id == submission.userId })
        cell.update(with: submission, user: user, votes: VoteController.shared.votes(for: submission))
        return cell
    }
    
}


// MARK: - Setup collectionView and ScrollView Delegate

extension FeedViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height)
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<collectionView.visibleCells.count {
            let cell = collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // now calculating closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: cell)!.item
            }
        }
        if closestCellIndex != -1 {
            self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
    }
    
}

extension UICollectionView {
    
    var centerPoint : CGPoint {
        return CGPoint(x: center.x + contentOffset.x, y: center.y + contentOffset.y);
    }
    
    var centerCellIndexPath: IndexPath? {
        return indexPathForItem(at: centerPoint)
    }
}
