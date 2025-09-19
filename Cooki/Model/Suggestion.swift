//
//  Suggestion.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//
// MARK: - Model
import SwiftUI
import Foundation

struct Suggestion: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let aiText: String
    let prepTime: (hour: Int, minute: Int)
    let servings: Int
}

// MARK: - Dummy Data
extension Suggestion {
    static let mockSuggestion: [Suggestion] = [
        Suggestion(image: Image("FillerFoodImage"), title: "Rogan Josh Lamb", aiText: "Meet your protein goals with this meal", prepTime: (hour: 2, minute: 0), servings: 4),
        Suggestion(image: Image("FillerFoodImage2"), title: "Lemon Chicken", aiText: "Meet your protein goals with this meal", prepTime: (hour: 0, minute: 50), servings: 2),
        Suggestion(image: Image("FillerFoodImage3"), title: "Beef Stir Fry", aiText: "Meet your protein goals with this meal", prepTime: (hour: 1, minute: 20), servings: 8),
        Suggestion(image: Image("FillerFoodImage4"), title: "Grilled Chicken Salad", aiText: "Meet your protein goals with this meal", prepTime: (hour: 1, minute: 50), servings: 3),
        Suggestion(image: Image("FillerFoodImage5"), title: "Spaghetti Bolognese", aiText: "Meet your protein goals with this meal", prepTime: (hour: 0, minute: 30), servings: 5)
    ]
}

