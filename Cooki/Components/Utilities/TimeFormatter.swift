//
//  TimeFormatter.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
// MARK: - Time Formatting Utility
struct TimeFormatter {
    static func formatPrepTime(hours: Int, minutes: Int) -> String {
        var components: [String] = []
        
        if hours > 0 {
            let hourText = hours == 1 ? "hour" : "hours"
            components.append("\(hours) \(hourText)")
        }
        
        if minutes > 0 {
            let minuteText = minutes == 1 ? "minute" : "minutes"
            components.append("\(minutes) \(minuteText)")
        }
        
        return components.isEmpty ? "0 minutes" : components.joined(separator: " ")
    }
}
