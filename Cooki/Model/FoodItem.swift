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
        PantryItemCard(imageName: "Oranges", title: "Orange Navel", quantity: "7", daysLeft: 3),
        PantryItemCard(imageName: "Tomato", title: "Gourmet Tomato", quantity: "5", daysLeft: 4),
        PantryItemCard(imageName: "Chicken", title: "Chicken Breast Fillet", quantity: "1.5kg", daysLeft: 0)
    ]
}
