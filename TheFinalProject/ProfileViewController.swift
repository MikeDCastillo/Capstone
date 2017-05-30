//
//  ProfileViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI

class ProfileViewController: UIViewController, Controller {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    let imagePicker = UIImagePickerController()
    var firebaseController = FirebaseController()
    fileprivate var appStoreURL: URL?
    
    // Life - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transparentColor = UIColor.black.withAlphaComponent(0.8)
        view.backgroundColor = transparentColor
        editButton.backgroundColor = .clear
        
        userUpdated(nil)
        fetchAppStoreURL()
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdated(_:)), name: NSNotification.Name.userUpdated, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        editButton.layer.cornerRadius = editButton.bounds.height / 2
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
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
 
    func userUpdated(_ sender: NSNotification?) {
        guard let currentUser = UserController.shared.currentUser else { return }
        updateAvatarImage(url: currentUser.avatarURL)
        userNameLabel.text = currentUser.username
    }
    
}

extension ProfileViewController {
    
    fileprivate func fetchAppStoreURL() {
        let settingsController = SettingsController()
        settingsController.getAppStoreURL { url in
            self.appStoreURL = url
        }
    }
    //FIXME: User placeholder
    fileprivate func updateAvatarImage(url: URL?, placeholder: UIImage? = #imageLiteral(resourceName: "meMeme0")) {
        avatarImageView.kf.setImage(with: url, placeholder: placeholder)
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


extension ProfileViewController {
    
    fileprivate func presentUsernameEditAlert() {
        let alertController = UIAlertController(title: "Edit User Name", message: "Update?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let textField = alertController.textFields?.first,
                let usernameText = textField.text else { return }
            self.saveUsername(usernameText.lowercased())
        }
        alertController.addTextField { textField in
            textField.placeholder = "Username"
            
            guard let currentUser = UserController.shared.currentUser else { return }
            textField.text = currentUser.username
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { _ in
                guard let text = textField.text?.lowercased() else { saveAction.isEnabled = false; return }
                saveAction.isEnabled = !text.isEmpty && currentUser.username != text
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        saveAction.isEnabled = false
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func inviteFriends() {
        let text = "Check out MemeMe in the app store and see if you can create the funniest meme"
        guard let appStoreURL = appStoreURL else { return }
        let activityViewController = UIActivityViewController(activityItems: [text, appStoreURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    fileprivate func giveFeedback() {
        let alertController = UIAlertController(title: "Mail Error", message: "There was an error finding your mail. Please login/enable Mail via your phone's settings", preferredStyle: .alert)
        let goBackAction = UIAlertAction(title: "Go Back", style: .default)
        alertController.addAction(goBackAction)
        guard MFMailComposeViewController.canSendMail() else { present(alertController, animated: true); return } // FIXME: error handling
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["mcastillo2089@sudomail.com"])
        composeVC.setSubject("App Feedback")
        composeVC.setMessageBody("How can I help you?", isHTML: false)
        
        present(composeVC, animated: true, completion: nil)
    }
    
    func saveUsername(_ username: String) {
        guard var updatedUser = UserController.shared.currentUser else { return }
        updatedUser.username = username
        UserController.shared.updateUser(updatedUser)
    }
    
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableView

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SettingsRow: Int, CaseCountable {
        
        case editUserName
        case inviteFriends
        case support
        
        var title: String {
            switch self {
            case .editUserName:
                return "Edit Username"
            case .inviteFriends:
                return "Invite Friends"
            case .support:
                return "Report Feedback"
            }
        }
        
    }
    
    // MARK: - Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRow.caseCount
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsRow = SettingsRow(rawValue: indexPath.row)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = settingsRow.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsRow = SettingsRow(rawValue: indexPath.row)!
        switch settingsRow {
        case .editUserName:
            presentUsernameEditAlert()
        case .inviteFriends:
            inviteFriends()
        case .support:
            giveFeedback()
        }
    }
    
}


// MARK: - Image Picker Delegate

extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated:true, completion: nil)
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        UserController.shared.saveAvatar(image: chosenImage)
        updateAvatarImage(url: nil, placeholder: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
