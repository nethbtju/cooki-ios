//
//  Date+Extensions.swift
//  Cooki
//
//  Created by Rohit Valanki on 6/1/2026.
//

import Foundation

extension Date {
    /// Returns date string in "yyyyMMdd" format (e.g., 20260106)
    var yyyMMdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
