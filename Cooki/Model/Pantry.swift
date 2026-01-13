//
//  Pantry.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//

import Foundation

// MARK: - Pantry Model
struct Pantry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var items: [UUID] // Item IDs
    var memberIds: [String] // User IDs (Firebase Auth UIDs) who have access
    var joinToken: String // Token to allow others to request to join
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String = "My Pantry",
        items: [UUID] = [],
        memberIds: [String] = [],
        joinToken: String = Pantry.generateJoinToken(), // Automatically generate a unique 8-char token
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.items = items
        self.memberIds = memberIds
        self.joinToken = joinToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Generate Random 8-Character Join Token
    static func generateJoinToken() -> String {
        let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        return String((0..<8).compactMap { _ in characters.randomElement() })
    }
}
