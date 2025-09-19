//
//  Recipe.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//
// MARK: - Model
import SwiftUI
import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let day: String
    let servings: Int
}

// MARK: - Dummy Data
extension Recipe {
    static let mockRecipes: [Recipe] = [
        Recipe(image: Image("FillerFoodImage"), title: "Rogan Josh Lamb", day: "Sat", servings: 4),
        Recipe(image: Image("FillerFoodImage2"), title: "Lemon Chicken", day: "Sun", servings: 2),
        Recipe(image: Image("FillerFoodImage3"), title: "Beef Stir Fry", day: "Mon", servings: 8),
        Recipe(image: Image("FillerFoodImage4"), title: "Grilled Chicken Salad", day: "Tue", servings: 3),
        Recipe(image: Image("FillerFoodImage5"), title: "Spaghetti Bolognese", day: "Wed", servings: 5)
    ]
}
