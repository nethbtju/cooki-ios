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
    var memberIds: [UUID] // User IDs who have access
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String = "My Pantry",
        items: [UUID] = [],
        memberIds: [UUID] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.items = items
        self.memberIds = memberIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
