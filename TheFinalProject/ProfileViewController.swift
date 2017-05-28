//
//  ProfileViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Kingfisher


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var newPictureCaptrured: Bool?
    
    // Life - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        //this is for simulator as of now
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        //this is the viewController that the banner will be displayed on
        bannerView.rootViewController = self
        bannerView.load(request)
        
        setupProfileImg()
    }

    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Change Profile Picture?", preferredStyle: .actionSheet)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) { (alert) in
            self.present(alertController, animated: true, completion: nil)
        }
        alertController.addAction(dismiss)
        let toPhotoLibrary = UIAlertAction(title: "Gallery 📷", style: .default) { (action) in
            self.setUpImagePicker()
        
//            self.imagePickerController(self.imagePicker, didFinishPickingMediaWithInfo: <#T##[String : Any]#>
        }
        alertController.addAction(toPhotoLibrary)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func setupProfileImg() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 3
        avatarImageView.clipsToBounds = true
    }
    
    func setUpImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        //required by apple for ipads
        imagePicker.modalPresentationStyle = .popover
//        self.imagePicker.popoverPresentationController?.barButtonItem = sender
        self.present(imagePicker, animated: true, completion: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum)  {
            self.newPictureCaptrured = false
        }
    }
    
    
    // MARK: - TableViewController & Delegate conformance
    
    class ProfileTableViewController: UITableViewController {
    
        enum TableViewCells: Int, CaseCountable {
            
            static let caseCount = TableViewCells.countCases()
            
            case editUserName
            case inviteFriends
            case versionBuild
            case contactDeveloper
            
            var cellsToDisplay: UITableViewCell {
                switch self {
                case .editUserName:
                    return UITableViewCell()
                case .inviteFriends:
                    return UITableViewCell()
                case .versionBuild:
                    return UITableViewCell()
                case .contactDeveloper:
                    return UITableViewCell()
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        // MARK: - Table view data source
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TableViewCells.caseCount
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            return cell
        }
        
    }
    
}


// MARK: - Image Picker Delegate

extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
