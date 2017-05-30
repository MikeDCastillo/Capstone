//
//  AnimationLaunchViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/30/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class AnimationLaunchViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate let animationDuration: TimeInterval = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imageView.alpha = 0
        animateLaunchScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        animateLaunchScreen(fadeOut: true)
    }
    
    var imageNames = ["meMeme0", "meMeme1", "meMeme2", "meMeme3", "meMeme4", "meMeme5", "meMeme6", "meMeme7", "meMeme8", "meMeme9"]

    func animateLaunchScreen() {
        let images = imageNames.reversed().flatMap { UIImage(named: $0) }
        imageView.animationImages = images
        imageView.animationDuration = animationDuration
        imageView.startAnimating()
        self.fadeIn()
        //FIXME: get this the way you want it
    }
    
    func fadeIn() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.imageView.alpha = 1
        }) { _ in
            self.imageView.stopAnimating()
            self.performSegue(withIdentifier: "toFeedStart", sender: self)
        }
    }
    
}
