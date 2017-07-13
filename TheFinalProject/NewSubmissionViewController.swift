//
//  NewSubmissionViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/20/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds

class NewSubmissionViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    @IBOutlet weak var colorSegmentControl: UISegmentedControl!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var viewTappedRecognizer: UITapGestureRecognizer!
    
    
    fileprivate var topText = "" {
        didSet {
            topLabel.text = topText
            let charCount = topText.characters.count
            topCounterLabel.text = "\(charCount)"
            topCounterLabel.textColor = charCount >= characterLimit ? .red : .black
            
            if charCount >= characterLimit {
                shakeTopText()
            }
            // sets bottomText before didSet On botom text is called
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
            
            if charCount >= characterLimit {
                shakeBottomText()
            }
            
        }
    }
    
    fileprivate var selectedIndex = 0 {
        didSet {
            currentColor = selectedIndex == 0 ? .white : .black
        }
    }
    
    fileprivate var currentColor = UIColor.white {
        didSet {
            topLabel.textColor = currentColor
            bottomLabel.textColor = currentColor
        }
    }
    fileprivate let characterLimit = 55
    fileprivate let submissionController = SubmissionController.shared
    fileprivate var meme: Meme? {
        return MemeController.shared.meme
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        colorPicker.delegate = self
        setupSaveButton()
        updateSaveButton()
        guard let meme = meme else { return }
        imageView.kf.setImage(with: meme.imageURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        //this is for simulator as of now
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        //this is the viewController that the banner will be displayed on
        bannerView.rootViewController = self
        bannerView.load(request)
        
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func colorSegmentControlValueChanged(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let meme = meme, let user = UserController.shared.currentUser else { return }
        let actualTopText: String? = topText.isEmpty ? nil : topText
        let actualBottomText: String? = bottomText.isEmpty ? nil : bottomText
        let newSubmission = Submission(id: "", userId: user.id, topText: actualTopText, bottomText: actualBottomText, textColor: currentColor, creationDate: Date(), blockedUsers: blockedUsers)
        submissionController.saveSubmission(newSubmission, memeId: meme.id)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    @IBAction func topLabelTapped(_ sender: UITapGestureRecognizer) {
        topTextField.becomeFirstResponder()
    }
    
    @IBAction func bottomLabelTapped(_ sender: UITapGestureRecognizer) {
        bottomTextField.becomeFirstResponder()
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
        saveButton.backgroundColor = hasText ? .mainAppColor : UIColor.mainAppColor.withAlphaComponent(0.3)
    }
    
}


// MARK: - TxtFieldDelegate

extension NewSubmissionViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTappedRecognizer.isEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.characters.count
        return numberOfChars <= characterLimit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewTappedRecognizer.isEnabled = false
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


// MARK: - colorPicker Delegate

extension NewSubmissionViewController: ColorDelegate {

    func pickedColor(color: UIColor) {
        currentColor = color
        colorSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
}

// MARK: - Animations & setup

extension NewSubmissionViewController {
    
    func shakeTopText(count : Float? = nil, for duration : TimeInterval? = nil, withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        topCounterLabel.layer.add(animation, forKey: "shake")
    }
    
    func shakeBottomText(count : Float? = nil, for duration : TimeInterval? = nil, withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        bottomCounterLabel.layer.add(animation, forKey: "shake")
    }
    
    func setupSaveButton() {
        saveButton.layer.cornerRadius = 10
    }
    
}

