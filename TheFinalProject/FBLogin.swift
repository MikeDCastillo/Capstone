//
//  FBLogin.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/30/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookLoginModalViewController: UIViewController {
    
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        view.addConstraint(loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60))
        view.addConstraint(loginButton.heightAnchor.constraint(equalToConstant: 44))
    }
    
}

extension FacebookLoginModalViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("error")
            return
        }
        print("Succesfully logged into Facebook")
    }
    
}
