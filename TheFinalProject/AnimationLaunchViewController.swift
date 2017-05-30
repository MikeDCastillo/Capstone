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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLaunchScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animateLaunchScreenAgain()
    }
    
    var imageNames = ["meMeme0", "meMeme1", "meMeme2", "meMeme3", "meMeme4", "meMeme5", "meMeme6", "meMeme7", "meMeme8", "meMeme9"]
    var reversedImageNames = ["meMeme9", "meMeme8", "meMeme7", "meMeme6", "meMeme5", "meMeme4", "meMeme3", "meMeme2", "meMeme1", "meMeme0"]

    func animateLaunchScreen () {
        var images = [UIImage]()
        
        for i in 0..<imageNames.count {
            //            guard let image = UIImage(named: "meMeme\(i)") else { break }
            images.append(UIImage(named: imageNames[i])!)
        }
        
        imageView.animationImages = images
        imageView.animationDuration = 2.0
        imageView.startAnimating()
        fadeOut()
        
    }
    
    func animateLaunchScreenAgain () {
        var images = [UIImage]()
        
        for i in 0..<reversedImageNames.count {
            //            guard let image = UIImage(named: "meMeme\(i)") else { break }
            images.append(UIImage(named: reversedImageNames[i])!)
        }
        
        imageView.animationImages = images
        imageView.animationDuration = 2.0
        imageView.startAnimating()
        fadeIn()
    }
    
    func fadeOut(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: { 
            self.imageView.alpha = 0.0
        }) { (_) in
            self.animateLaunchScreenAgain()

        }
    }
    
    func fadeIn(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.imageView.alpha = 1.0
        }) { (_) in
            self.imageView.stopAnimating()
//            self.imageView.image = UIImage(named: "troll")
            self.performSegue(withIdentifier: "toFeedStart", sender: nil)
    }
}
}
