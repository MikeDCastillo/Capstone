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
    
    enum SortType: String {
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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var voteToggleButton: UIButton!
    @IBOutlet weak var lolButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var wtfButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate var lolButtonCenter: CGPoint!
    fileprivate var dislikeButtonCenter: CGPoint!
    fileprivate var wtfButtonCenter: CGPoint!
    fileprivate let userController = UserController.shared
    fileprivate let memeController = MemeController.shared
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate let voteToggleString = "Vote Toggle"
    fileprivate let voteTypeString = "Vote Type"
    
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
        loadCurrentUser()
        memeController.getTodaysMeme()
        
        let nibId = String(describing: SubmissionCollectionViewCell.self)
        let nib = UINib(nibName: nibId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibId)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        setupVoteButton()
        setupUIButtons()
        
        scrollViewDidEndDragging(collectionView, willDecelerate: true)
        scrollViewDidEndDecelerating(collectionView)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(memeUpdated(_:)), name: NSNotification.Name.todaysMemeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submissionsUpdated(_:)), name: NSNotification.Name.submissionUpdated, object: nil)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        //this is for simulator as of now
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        //this is the viewController that the banner will be displayed on
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    // MARK: - Actions
    
    @IBAction func VoteToggleButtonPressed(_ sender: UIButton) {
        
        if voteToggleButton.currentTitle == voteToggleString {
            UIView.animate(withDuration: 0.4, animations: {
                self.lolButton.alpha = 1
                self.dislikeButton.alpha = 1
                self.wtfButton.alpha = 1
                // move out animation
                self.lolButton.center = self.lolButtonCenter
                self.dislikeButton.center = self.dislikeButtonCenter
                self.wtfButton.center = self.wtfButtonCenter
            })
        } else {
            self.lolButton.alpha = 0
            self.dislikeButton.alpha = 0
            self.wtfButton.alpha = 0
            // move in
            UIView.animate(withDuration: 0.4, animations: {
                self.voteToggleButton.center = self.lolButton.center
                self.voteToggleButton.center = self.dislikeButton.center
                self.voteToggleButton.center = self.wtfButton.center
            })
        }
        //setting button text
        toggleVoteButtonText(on: sender, voteToggle: voteToggleString, voteType: voteTypeString)
    }
    
    @IBAction func lolButtonTapped(_ sender: UIButton) {
        // animate button here
        toggleVoteButtonText(on: voteToggleButton, voteToggle: voteToggleString, voteType: voteTypeString)
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // animate button here
        toggleVoteButtonText(on: voteToggleButton, voteToggle: voteToggleString, voteType: voteTypeString)
        
    }
    
    @IBAction func wtfButtonTapped(_ sender: UIButton) {
        // animate button here
        toggleVoteButtonText(on: voteToggleButton, voteToggle: voteToggleString, voteType: voteTypeString)
    }
    
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
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        
        if submissions.count > 0 {
            guard ((self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)) != nil) else { return }
        } else {
            presentAlertController()
        }
    }
    
    @IBAction func lastButtonTapped(_ sender: Any) {
        let section = 0
        let lastItem = self.collectionView.numberOfItems(inSection: section) - 1
        let indexPath = IndexPath.init(row: lastItem, section: section)
        if submissions.count > 0 {
            guard ((self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)) != nil) else { return }
        } else {
            presentAlertController()
        }
    }
    
    func memeUpdated(_ notification: NSNotification) {
        guard let todaysMeme = todaysMeme else { return }
        imageView.kf.setImage(with: todaysMeme.imageURL)
    }
    
    func submissionsUpdated(_ notification: NSNotification) {
        collectionView.reloadData()
    }
    
    func toggleVoteButtonText (on uiButton: UIButton, voteToggle: String, voteType: String) {
        if uiButton.currentTitle == "Vote Toggle" {
            uiButton.setTitle("Vote Type", for: .normal)
        } else {
            uiButton.setTitle("Vote Toggle", for: .normal)
        }
    }
    
    
}


// MARK: - Fileprivate

extension FeedViewController {
    
    fileprivate func loadCurrentUser() {
        userController.loadCurrentUser { user, iCloudId in
            if let _ = user {
                print("User was found")
                return // User was loaded successfully and all is right in the world
            } else if let iCloudId = iCloudId {
                print("User was not found but we got an ICloudID: \(iCloudId)")
                self.createUser(with: iCloudId)
                // Show onboarding experience
            } else {
                print("ICLOUD FAIL!!!!!!")
                // Show iCloudError alert
            }
        }
    }
    
    fileprivate func createUser(with iCloudId: String) {
        print("Creating USER NOW")
        self.userController.createUser(iCloudId: iCloudId, username: "", completion: { error in
            if let error = error {
                print(error)
                print("UH OH")
            } else {
                print("Welcome. You are the newest user")
                dump(self.userController.currentUser)
            }
        })
    }
    
    fileprivate func setupVoteButton() {
        voteButton.layer.cornerRadius = 10
    }
    
    fileprivate func presentAlertController() {
        let alertController = UIAlertController(title: "Create A Meme", message: "You need to have some memes created to use this Button", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's Create One!", style: .default) { (alert) in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
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
                closestCellIndex = collectionView.indexPath(for: cell)!.row
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


// MARK: - setup Buttons

extension FeedViewController {
    
    func setupUIButtons() {
        // To cache CG point postions of UI Buttons
        lolButtonCenter = lolButton.center
        dislikeButtonCenter = dislikeButton.center
        wtfButtonCenter = wtfButton.center
        //setting the initail GGPoint of buttons under the vote button. then setting the CGPoints where they live when pulled back under the vote button
        lolButton.center = voteToggleButton.center
        dislikeButton.center = voteToggleButton.center
        wtfButton.center = voteToggleButton.center
    }
}
