//
//  FoodItem.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
// MARK: - Model
import SwiftUI
import Foundation

struct PantryItem: Identifiable {
    let id = UUID()
    var image: Image
    var title: String
    var quantity: String
    var daysLeft: Int
    var location: String?
}

// MARK: - Dummy Data
extension PantryItem {
    static let mockPantrytems: [PantryItem] = [
        PantryItem(image: Image("StrawberryJam"), title: "Cottee's Strawberry Jam", quantity: "375g", daysLeft: 3, location: "Fridge"),
        PantryItem(image: Image("Milk"), title: "Full Cream Milk", quantity: "1L", daysLeft: 1, location: "Fridge"),
        PantryItem(image: Image("Bananas"), title: "Bananas", quantity: "7", daysLeft: 0, location: "Pantry"),
        PantryItem(image: Image("StrawberryJam"), title: "Cottee's Strawberry Jam", quantity: "375g", daysLeft: 3, location: "Pantry"),
        PantryItem(image: Image("Milk"), title: "Full Cream Milk", quantity: "1L", daysLeft: 1, location: "Freezer")
    ]
}
