//
//  ICloudViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class ICloudViewController: UIViewController {

    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    fileprivate let cornerRadius: CGFloat = 5.0
    
    fileprivate var isLoading = false {
        didSet{
            let title = isLoading ? "..." : "🔄 Try Again 🔄"
            DispatchQueue.main.async {
                self.tryAgainButton.setTitle(title, for: .normal)
                
            }
            tryAgainButton.isEnabled = !isLoading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadiCloud), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        tryAgainButton.layer.cornerRadius = cornerRadius
        settingsButton.layer.cornerRadius = cornerRadius
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, completionHandler: nil)
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        reloadiCloud()
    }

}

extension ICloudViewController {
    
    func reloadiCloud() {
        isLoading = true
        UserController.shared.loadCurrentUser { (user, id) in
            if let _ = id {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.isLoading = false
            }
        }
    }
    
}
