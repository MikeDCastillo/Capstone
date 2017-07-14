//
//  TermsViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 7/14/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func agreeButtonPressed(_ sender: UIBarButtonItem) {
        markUserAgreedToTerms()
    }
    
}

private extension TermsViewController {
    
    func markUserAgreedToTerms() {
        guard var currentUser = UserController.shared.currentUser else { return }
        currentUser.hasAgreedToTerms = true
        UserController.shared.updateUser(currentUser) { error in
            DispatchQueue.main.async {
                if let _ = error {
                    self.displayErrorAlert()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func displayErrorAlert() {
        let alert = UIAlertController(title: "Error saving your data", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "😞", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
