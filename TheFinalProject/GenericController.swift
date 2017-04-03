//
//  GenericController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/1/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GenericController: Controller {
    
    func updateObject<T: Identifiable>(object: T) {
        firebaseController.save(at: object.ref, json: object.json()) { error in
            <#code#>
        }
    }

}
