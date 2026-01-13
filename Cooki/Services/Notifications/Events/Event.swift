//
//  Event.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/1/2026.
//

import Foundation

// MARK: - Event Model
struct Event: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var message: String
    var priority: Int
    var timestamp: Date
    var readBy: [String]
    var type: EventType

    // Optional fields for action events
    var actionIdentifier: String?
    var actionPayload: [String: String]?

    // MARK: - Helper functions
    func isRead(by userId: String) -> Bool {
        return readBy.contains(userId)
    }

    mutating func markAsRead(by userId: String) {
        if !readBy.contains(userId) {
            readBy.append(userId)
        }
    }
}

// MARK: - Event Type Enum
enum EventType: String, Codable {
    case newItem
    case joinRequestCreated
    case joinRequestFailed
    case joinRequestAccepted
    case joinRequestDenied
    case newMember          // ✅ Added: pantry-level event for new member
    case action
    case reminder
    case general
}
