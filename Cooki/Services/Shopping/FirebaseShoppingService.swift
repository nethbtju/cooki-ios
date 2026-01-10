//
//  FirebaseShoppingService.swift
//  Cooki
//
//  Created by Neth Botheju on 10/1/2026.
//
// MARK: - Mock Implementation (for testing)
class ShoppingService: ShoppingServiceProtocol {
    func fetchItems() async throws -> [Item] {
        // TODO: Replace with Firebase call
        try await Task.sleep(nanoseconds: 500_000_000)
        return Item.mockItems
    }
    
    func addItem(_ item: Item) async throws -> Item {
        // TODO: Replace with Firebase call
        try await Task.sleep(nanoseconds: 300_000_000)
        return item
    }
    
    func updateItem(_ item: Item) async throws -> Item {
        // TODO: Replace with Firebase call
        try await Task.sleep(nanoseconds: 300_000_000)
        return item
    }
    
    func deleteItem(_ itemId: String) async throws {
        // TODO: Replace with Firebase call
        try await Task.sleep(nanoseconds: 300_000_000)
    }
    
    func deleteMultipleItems(_ itemIds: [String]) async throws {
        // TODO: Replace with Firebase call
        try await Task.sleep(nanoseconds: 300_000_000)
    }
}
