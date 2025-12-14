//
//  TimeFormatter.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
// MARK: - TimeComponents
struct TimeComponents: Equatable, Hashable {
    let hours: Int
    let minutes: Int

    enum Style {
        case short
        case long
    }

    func string(_ style: Style = .long) -> String {
        var parts: [String] = []

        switch style {
        case .short:
            if hours > 0 { parts.append("\(hours)h") }
            if minutes > 0 { parts.append("\(minutes)m") }

        case .long:
            if hours > 0 {
                parts.append("\(hours) hr" + (hours > 1 ? "s" : ""))
            }
            if minutes > 0 {
                parts.append("\(minutes) min")
            }
        }

        return parts.isEmpty ? (style == .short ? "0m" : "0 min") : parts.joined(separator: " ")
    }
}
