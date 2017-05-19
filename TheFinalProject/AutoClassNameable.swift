//
//  AutoClassNameable.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/18/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
protocol AutoClassNameable { }

extension AutoClassNameable {
    /// This returns the class name as a string
    static var className: String {
        return String(describing: self)
    }
    
}
