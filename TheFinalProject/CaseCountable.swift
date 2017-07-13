//
//  CaseCountable.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/27/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

// enum which returns count of cases
protocol CaseCountable { }


// count the cases for Int enums assuming start at 0
extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    // count the number of cases in the enum
    static var caseCount: Int {
        // starting at zero, verify whether the enum can be instantiated from the Int and increment until it cannot
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
}
