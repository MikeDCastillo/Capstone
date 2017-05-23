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
    
    
    fileprivate var topText = "" {
        didSet {
            topLabel.text = topText
            let charCount = topText.characters.count
            topCounterLabel.text = "\(charCount)"
            topCounterLabel.textColor = charCount >= characterLimit ? .red : .black
            
            if bottomText.isEmpty {
                bottomText = ""
            }
        }
    }
    
    fileprivate var bottomText = "" {
        didSet {
            bottomLabel.text = bottomText
            let charCount = bottomText.characters.count
            bottomCounterLabel.text = "\(charCount)"
            bottomCounterLabel.textColor = charCount == characterLimit ? .red : .black
        }
    }
    
    fileprivate let characterLimit = 40
    fileprivate let submissionController = SubmissionController.shared
    fileprivate var meme: Meme? {
        return MemeController.shared.meme
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButton()
        guard let meme = meme else { return }
        imageView.kf.setImage(with: meme.imageURL)
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let meme = meme, let user = UserController.shared.currentUser else { return }
        let actualTopText: String? = topText.isEmpty ? nil : topText
        let actualBottomText: String? = bottomText.isEmpty ? nil : bottomText
        let newSubmission = Submission(id: "", userId: user.id, topText: actualTopText, bottomText: actualBottomText, textColor: .white, creationDate: Date(), voteIds: [])
        submissionController.saveSubmission(newSubmission, memeId: meme.id)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender == topTextField {
            topText = sender.text ?? ""
        } else {
            bottomText = sender.text ?? ""
        }
        updateSaveButton()
    }
    
}


// MARK: - Fileprivate

extension NewSubmissionViewController {
    
    fileprivate func updateSaveButton() {
        guard let topText = topTextField.text, let bottomText = bottomTextField.text else { saveButton.isEnabled = false; return }
        let hasText = !topText.isEmpty || !bottomText.isEmpty
        saveButton.isEnabled = hasText
        saveButton.backgroundColor = hasText ? .green : UIColor.blue.withAlphaComponent(0.3)
    }
    
}

// MARK: - TxtFieldDelegate

extension NewSubmissionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.characters.count
        return numberOfChars <= characterLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topTextField {
            bottomTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

