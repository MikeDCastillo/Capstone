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


class ProfileViewController: UIViewController, Controller {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var firebaseController = FirebaseController()
    
    // Life - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateAvatarImage()
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdated(_:)), name: NSNotification.Name.userUpdated, object: nil)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //this is for simulator as of now
        //FIXME: no magic strings in here
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        //this is the viewController that the banner will be displayed on
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        editButton.layer.cornerRadius = editButton.bounds.height / 2
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Change Profile Picture?", preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        let cameraAction = UIAlertAction(title: "Camera 📷", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera )
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
            
        let photoLibraryAction = UIAlertAction(title: "Photo Library 🌄", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary )
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(photoLibraryAction)
        }
        let deleteAction = UIAlertAction(title: "Delete Avatar", style: .destructive) { _ in
            self.deleteUserAvatar()
        }
        if let currentUser = UserController.shared.currentUser, let _ = currentUser.avatarURLString {
            alertController.addAction(deleteAction)
        }
        present(alertController, animated: true, completion: nil)
    }
 
    func userUpdated(_ sender: NSNotification) {
        updateAvatarImage()
    }
    
}

extension ProfileViewController {
    
    //FIXME: User placeholder
    fileprivate func updateAvatarImage(placeholder: UIImage? = #imageLiteral(resourceName: "meMeme0")) {
        guard let currentUser = UserController.shared.currentUser else { return }
        avatarImageView.kf.setImage(with: currentUser.avatarURL, placeholder: placeholder)
        print("SETTING URL: ->\(currentUser.avatarURL), placeholder: \(placeholder)")
    }
    
    fileprivate func deleteUserAvatar() {
        guard let currentUser = UserController.shared.currentUser, let _ = currentUser.avatarURLString else { return }
        var updatedUser = currentUser
        updatedUser.avatarURLString = nil
        UserController.shared.updateUser(updatedUser)
    }
    
    fileprivate func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        if sourceType == .camera {
            imagePicker.cameraCaptureMode = .photo
        }
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}


// MARK: - TableView

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum TableViewCells: Int, CaseCountable {
        
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
    
    // MARK: - Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCells.caseCount
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
}


// MARK: - Image Picker Delegate

extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated:true, completion: nil)
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        UserController.shared.saveAvatar(image: chosenImage)
        updateAvatarImage(placeholder: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
