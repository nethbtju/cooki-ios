//
//  PantryViewModel.swift
//  Cooki
//

import SwiftUI

@MainActor
class PantryViewModel: ObservableObject {

    @Published var pantryItems: [Item] = []
    @Published var sections: [StorageLocation] = [.pantry, .fridge, .freezer]

    private let pantryService = FirebasePantryService()
    private let itemService = FirebaseItemService()

    // MARK: - Init
    init(useMockData: Bool = AppConfig.useMockData) {
        Task {
            await fetchCurrentPantryItems(useMockData: useMockData)
        }
    }

    // MARK: - Fetch Pantry Items
    func fetchCurrentPantryItems(useMockData: Bool = false) async {
        do {
            let pantry = try await pantryService.fetchCurrentUserPantry()

            print("🧺 Active pantry:", pantry.id.uuidString)

            // ⚠️ Only add mock items in dev mode
            if useMockData && pantry.items.isEmpty {
                try await addMockItems(to: pantry)
            }

            // Fetch items by pantry item IDs
            let items = try await itemService.fetchItems(byIds: pantry.items)
            self.pantryItems = items

        } catch {
            print("❌ Failed to fetch pantry items:", error.localizedDescription)
        }
    }

    // MARK: - Add Mock Items
    private func addMockItems(to pantry: Pantry) async throws {
        for item in Self.mockItems {
            // Assign the current pantryId to each mock item
            var itemWithPantry = item
            itemWithPantry.pantryId = pantry.id

            try await itemService.saveItem(itemWithPantry)
            try await pantryService.addItem(
                itemId: itemWithPantry.id,
                toPantryId: pantry.id
            )
        }
        print("✅ Mock items added to pantry:", pantry.name)
    }

    // MARK: - Helpers
    func items(for location: StorageLocation) -> [Item] {
        pantryItems.filter { $0.location == location }
    }

    // MARK: - Mock Data
    static let mockItems: [Item] = {
        var items: [Item] = []
        let titles = [
            "Milk", "Eggs", "Apple", "Chicken Breast", "Rice", "Bananas",
            "Cottee's Strawberry Jam", "Full Cream Milk", "Cheddar Cheese",
            "Broccoli", "Carrots", "Yogurt", "Orange Juice", "Pasta", "Tomato Sauce"
        ]
        let locations: [StorageLocation] = [.fridge, .freezer, .pantry, .cupboard]
        let categories: [ItemCategory] = [.dairy, .meat, .produce, .grains, .condiments, .beverages, .snacks, .frozen, .other]

        for _ in 0..<25 {
            let title = titles.randomElement() ?? "Item"
            let location = locations.randomElement() ?? .pantry
            let category = categories.randomElement() ?? .other
            let quantityValue = Double(Int.random(in: 1...10))
            let quantityUnit: Item.Quantity.Unit = [.grams, .kilograms, .milliliters, .liters, .pieces].randomElement() ?? .pieces
            let expiryDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...15), to: Date())

            let item = Item(
                title: title,
                quantity: Item.Quantity(value: quantityValue, unit: quantityUnit),
                expiryDate: expiryDate,
                location: location,
                category: category,
                pantryId: UUID()
            )
            items.append(item)
        }
        return items
    }()
}
