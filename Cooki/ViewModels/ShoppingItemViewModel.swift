//
//  ItemViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 8/1/2026.
//
import Foundation
import SwiftUI

@MainActor
class ShoppingListViewModel: ObservableObject {
    
    @Published var Items: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Filter states
    @Published var showOnlyUnchecked = false
    @Published var selectedCategory: ItemCategory?
    @Published var searchText = ""
    
    // Dependencies
    private let shoppingService: ShoppingServiceProtocol
    
    init(
        shoppingService: ShoppingServiceProtocol = ShoppingService(),
    ) {
        self.shoppingService = shoppingService
        
        // Load initial data
        Task {
            await loadItems()
        }
    }
    
    // MARK: - Derived State
    
    var filteredItems: [Item] {
        var items = Items
        
        // Filter by checked status
        if showOnlyUnchecked {
            items = items.filter { !$0.addedToCart }
        }
        
        // Filter by category
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            items = items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items.sorted { !$0.addedToCart && $1.addedToCart } // Unchecked first
    }
    
    var itemsByCategory: [ItemCategory: [Item]] {
        Dictionary(grouping: filteredItems) { $0.category }
    }
    
    var totalItems: Int {
        Items.count
    }
    
    var checkedItems: Int {
        Items.filter { $0.addedToCart }.count
    }
    
    var progress: Double {
        guard totalItems > 0 else { return 0 }
        return Double(checkedItems) / Double(totalItems)
    }
    
    // MARK: - Public Methods
    
    func loadItems() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let items = try await shoppingService.fetchItems()
            Items = items
        } catch {
            errorMessage = "Failed to load shopping items: \(error.localizedDescription)"
            print("Error loading shopping items: \(error)")
        }
    }
    
    func addItem(_ item: Item) async {
        do {
            let newItem = try await shoppingService.addItem(item)
            Items.append(newItem)
        } catch {
            errorMessage = "Failed to add item: \(error.localizedDescription)"
            print("Error adding item: \(error)")
        }
    }
    
    func updateItem(_ item: Item) async {
        do {
            let updatedItem = try await shoppingService.updateItem(item)
            if let index = Items.firstIndex(where: { $0.id == item.id }) {
                Items[index] = updatedItem
            }
        } catch {
            errorMessage = "Failed to update item: \(error.localizedDescription)"
            print("Error updating item: \(error)")
        }
    }
    
    func deleteItem(_ item: Item) async {
        do {
            try await shoppingService.deleteItem(item.id.uuidString)
            Items.removeAll { $0.id == item.id }
        } catch {
            errorMessage = "Failed to delete item: \(error.localizedDescription)"
            print("Error deleting item: \(error)")
        }
    }
    
    func toggleItemCart(_ item: Item) async {
        var updatedItem = item
        updatedItem.toggleCart()
        await updateItem(updatedItem)
    }
    
    func updateQuantity(_ item: Item, quantity: Double) async {
        var updatedItem = item
        updatedItem.updateQuantity(quantity)
        await updateItem(updatedItem)
    }
    
    func clearCheckedItems() async {
        let checkedItems = Items.filter { $0.addedToCart }
        
        do {
            try await shoppingService.deleteMultipleItems(
                checkedItems.map { $0.id.uuidString }
            )
            Items.removeAll { $0.addedToCart }
        } catch {
            errorMessage = "Failed to clear checked items: \(error.localizedDescription)"
            print("Error clearing items: \(error)")
        }
    }
}
