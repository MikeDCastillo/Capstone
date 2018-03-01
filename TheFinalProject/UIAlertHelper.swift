//
//  UIAlertHelper.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 2/24/18.
//  Copyright © 2018 Michael Castillo. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func dismissAfterDelay(on alertController: UIAlertController, with time: Int) {
        
        // change to desired number of seconds
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alertController.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
