//
//  FoodItem.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
// MARK: - Model
import SwiftUI
import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let day: String
    let servings: Int
}

// MARK: - Dummy Data
extension FoodItem {
    static let mockFoodItem: [PantryItemCard] = [
        PantryItemCard(imageName: "StrawberryJam", title: "Cottee's Strawberry Jam", quantity: "375g", daysLeft: 3),
        PantryItemCard(imageName: "Milk", title: "Full Cream Milk", quantity: "1L", daysLeft: 1),
        PantryItemCard(imageName: "Bananas", title: "Bananas", quantity: "7", daysLeft: 0),
        PantryItemCard(imageName: "StrawberryJam", title: "Cottee's Strawberry Jam", quantity: "375g", daysLeft: 3),
        PantryItemCard(imageName: "Milk", title: "Full Cream Milk", quantity: "1L", daysLeft: 1)
    ]
}
