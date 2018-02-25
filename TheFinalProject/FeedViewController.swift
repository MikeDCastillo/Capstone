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
import SceneKit
import Firebase

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
    @IBOutlet weak var dailyVotesLabel: UILabel!
    @IBOutlet var originalVoteConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var flagButton: UIButton!
    //TODO: - implement activity indicator for UX
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var likeButtonCenter: CGPoint!
    fileprivate var dislikeButtonCenter: CGPoint!
    fileprivate var wtfButtonCenter: CGPoint!
    fileprivate let userController = UserController.shared
    fileprivate let memeController = MemeController.shared
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate var feedbackGenerator: UINotificationFeedbackGenerator?
    fileprivate let iCloudSegue = "iCloudSegue"
    fileprivate let maxVotes = 7
    
    fileprivate var submissions =  [Submission]()
    fileprivate var votesUsed = 0
    var shouldEditUsername = false
    fileprivate var canVote: Bool {
        return votesUsed < maxVotes
    }
    fileprivate var currentSortType = SortType.likes {
        didSet {
            submissions = SubmissionController.shared.submissions.sorted(by: currentSortType.sort)
            collectionView.reloadData()
        }
    }
    fileprivate var todaysMeme: Meme? {
        return MemeController.shared.meme
    }
    fileprivate var users: [User] {
        return Array(UserController.shared.users)
    }
    fileprivate var dailyVotes: [Vote] {
        return Array(VoteController.shared.votes)
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setupUIButtons()
        memeController.getTodaysMeme()
        SubmissionController.shared.subscribeToFlagThreshold()
        currentSortType = SortType.recent
        feedbackGenerator = UINotificationFeedbackGenerator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(memeUpdated(_:)), name: NSNotification.Name.todaysMemeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submissionsUpdated(_:)), name: NSNotification.Name.submissionUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated(_:)), name: NSNotification.Name.votesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated(_:)), name: NSNotification.Name.usersUpdated, object: nil)
        likeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        wtfButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detectSubmissionFlagCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCurrentUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldEditUsername = false
    }
    
    // MARK: - Actions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        guard let type = SortType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentSortType = type
    }
    
    @IBAction func voteButtonTapped(_ sender: UIButton) {
        if let currentUser = UserController.shared.currentUser, let _ = currentUser.username {
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
        } else {
            presentLoginAlert()
        }
    }
    
    //Like Buttons
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        saveVoteLike(ofType: .like)
    }
    
    fileprivate func saveVoteLike(ofType type: VoteType) {
        guard let currentSubmission = currentSubmission() else { return }
        if canVote {
            
            ///////
            //FIXME: - fix vote types by implementing Switch statement for cleaner, less redundant code
            ///////
            VoteController.shared.vote(.like, on: currentSubmission)
            
        } else {
            print("TOO MANY VOTES!")
            tapped()
            shake()
            dailyVotesLabel.textColor = .red
            labelSize()
            //FIXME: Handle max votes
        }
    }
    
    //Dislike Buttons
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        saveVoteDislike(ofType: .dislike)
    }
    
    fileprivate func saveVoteDislike(ofType type: VoteType) {
        guard let currentSubmission = currentSubmission() else { return }
        if canVote {
            
            ///////
            //FIXME: - fix vote types by implementing Switch statement for cleaner, less redundant code
            ///////
            VoteController.shared.vote(.dislike, on: currentSubmission)
            
        } else {
            print("TOO MANY VOTES!")
            tapped()
            shake()
            dailyVotesLabel.textColor = .red
            labelSize()
            //FIXME: Handle max votes
        }
    }
    
    //WTF Buttons
    
    @IBAction func wtfButtonTapped(_ sender: UIButton) {
        saveVoteWtf(ofType: .wtf)
    }
    
    fileprivate func saveVoteWtf(ofType type: VoteType) {
        guard let currentSubmission = currentSubmission() else { return }
        if canVote {
            
            ///////
            //FIXME: - fix vote types by implementing Switch statement for cleaner, less redundant code
            ///////
            VoteController.shared.vote(.wtf, on: currentSubmission)
            
        } else {
            print("TOO MANY VOTES!")
            tapped()
            shake()
            dailyVotesLabel.textColor = .red
            labelSize()
            //FIXME: Handle max votes
        }
    }
    
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
        let previous = sender == previousButton
        moveCell(previous: previous)
    }
    
    @IBAction func flagButtonTapped(_ sender: Any) {
        guard let currentSubmission = currentSubmission() else { return }
        let alertController = UIAlertController(title: "", message: "Are you sure you want to report this?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { _ in
            SubmissionController.shared.report(currentSubmission)
            
        }
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func memeUpdated(_ notification: NSNotification) {
        guard let todaysMeme = todaysMeme else { return }
        ///// FIXME: - add Activity indicator
        
        imageView.kf.setImage(with: todaysMeme.imageURL)
        
        if imageView.image == nil {
         
        } else {
            
        }
        
        
    }
    
    func submissionsUpdated(_ notification: NSNotification) {
        submissions = SubmissionController.shared.submissions.sorted(by: currentSortType.sort)
        collectionView.reloadData()
    }
    
    func dataUpdated(_ notification: NSNotification) {
        updateVoteCount()
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
    
   fileprivate func setUpAds() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    //FIXME: Broken Animation. drag out outlet to connect
    //    func animateWithParticles() {
    //        SCNTransaction.begin()
    //        let scene = SCNScene()
    //        let particlesNode = SCNNode()
    //        guard let particleSystem = SCNParticleSystem(named: "MeMeMe", inDirectory: "") else { return }
    //        particlesNode.addParticleSystem(particleSystem)
    //        scene.rootNode.addChildNode(particlesNode)
    //        particlesView.scene = scene
    //
    //        SCNTransaction.commit()
    //    }
    //
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
        guard let indexPath = collectionView.centerCellIndexPath else  { return nil }
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
    
    fileprivate func presentLoginAlert() {
        let alertController = UIAlertController(title: "Login Required", message: "Please login to use this feature", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .default) { (_) in
            self.shouldEditUsername = true
            self.performSegue(withIdentifier: "toSettingsVC", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
   fileprivate func updateVoteCount() {
        guard let currentUser = userController.currentUser else { return }
        votesUsed = dailyVotes.filter { $0.userId == currentUser.id }.count
        let votesRemaining = max(maxVotes - votesUsed, 0)
        dailyVotesLabel.text = "\(votesRemaining) Votes Remain Today"
    }
    
    // MARK: - animations when dialy votes exceded

    
    @objc fileprivate func tapped() {
        //        let generator = UIImpactFeedbackGenerator(style: .heavy)
        //        generator.impactOccurred()
        feedbackGenerator?.notificationOccurred(.success)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    fileprivate func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        dailyVotesLabel.layer.add(animation, forKey: "shake")
    }
    
    fileprivate func labelSize() {
        dailyVotesLabel.transform = CGAffineTransform(scaleX: 1.9, y: 0.6)
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.dailyVotesLabel.transform = CGAffineTransform.identity }, completion: { Void in()
        })
    }
    
    fileprivate func detectSubmissionFlagCount() {
        guard let currentSubmission = currentSubmission() else { return}
        
        switch flagButton.isHidden {
        case true:
            _ = currentSubmission.flagCount >= 1
        case false:
            _ = currentSubmission.flagCount < 1
        default:
            break
        }
    }

}


extension FeedViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingsVC", let profileVC = segue.destination as? ProfileViewController {
            profileVC.shouldEditUsername = shouldEditUsername
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
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
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

// MARK: - setup constraints and positions of labels/buttons


extension UICollectionView {
    
    var centerPoint : CGPoint {
        return CGPoint(x: center.x + contentOffset.x, y: center.y + contentOffset.y);
    }
    
    var centerCellIndexPath: IndexPath? {
        return indexPathForItem(at: centerPoint)
    }
    
//    func showActivityIndicator(view: UIView) {
//        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 0.40, height: 0.40)
//        activityIndicator.center = view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        
//    }
    
}
