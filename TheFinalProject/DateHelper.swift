//
//  DateHelper.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/24/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

fileprivate enum DateHelper {
    
    static let formatter = ISO8601DateFormatter()
}

extension Date {
    
    /// Ex.  2017-02-16
    var dayString: String {
        DateHelper.formatter.formatOptions = [.withFullDate]
        return DateHelper.formatter.string(from: self)
    }
    
    /// Ex. 2017-03-25T05:16:29Z
    var fullDateString: String {
        DateHelper.formatter.formatOptions = [.withFullDate, .withFullTime]
        return DateHelper.formatter.string(from: self)
    }
    
    init?(dateString: String) {
        DateHelper.formatter.formatOptions = [.withFullDate, .withFullTime]
        if let date = DateHelper.formatter.date(from: dateString) {
            self = date
        } else {
            DateHelper.formatter.formatOptions = [.withFullDate]
            guard let date = DateHelper.formatter.date(from: dateString) else { return nil }
            self = date
        }
    }
}
