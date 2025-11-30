//
//  PantryServiceProtocol.swift
//  Cooki
//
//  Created on 29/11/2025.
//

import Foundation

protocol PantryServiceProtocol {
    /// Fetch a pantry by ID
    func fetchPantry(id: UUID) async throws -> Pantry
    
    /// Fetch multiple pantries by IDs
    func fetchPantries(ids: [UUID]) async throws -> [Pantry]
    
    /// Create a new pantry
    func createPantry(name: String, memberIds: [String]) async throws -> Pantry
    
    /// Update pantry details
    func updatePantry(_ pantry: Pantry) async throws
    
    /// Add item to pantry
    func addItem(itemId: UUID, toPantryId: UUID) async throws
    
    /// Remove item from pantry
    func removeItem(itemId: UUID, fromPantryId: UUID) async throws
    
    /// Add member to pantry
    func addMember(userId: String, toPantryId: UUID) async throws
    
    /// Remove member from pantry
    func removeMember(userId: String, fromPantryId: UUID) async throws
}
