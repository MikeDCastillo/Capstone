//
//  UserHomeViewController.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit
import Firebase

class UserHomeViewController: UIViewController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived), name: .messagesUpdated, object: nil)
    }
    
    // FIXME: There is no way to sign in so don't let them sign out
//    @IBAction func signOutButtonTapped(_ sender: Any) {
//        try! Auth.auth().signOut()
//        navigationController?.popViewController(animated: true)
//    }
    
    func newMessageReceived() {
        showNotificationBanner()
    }
    
}


extension UserHomeViewController: SegueHandling {
    
    enum SegueIdentifier: String {
        case userHomeVCToMessageConvoVC
        case toCarDetail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .userHomeVCToMessageConvoVC:
            UserController.shared.selectedUserId = UserController.shared.currentUserId
        case .toCarDetail:
            let selectedUser = CarDetailViewController.shared.user
            guard let detailVC = segue.destination as? CarDetailViewController else { return }
            detailVC.user = selectedUser
        }
    }

}
