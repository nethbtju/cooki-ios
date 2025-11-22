//
//  Suggestion.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - Suggestion Reason
enum SuggestionReason: String, Codable {
    case expiringIngredients = "Uses expiring ingredients"
    case nutritionGoals = "Meets your nutrition goals"
    case dietaryPreference = "Matches your dietary preferences"
    case popularRecipe = "Popular recipe"
    case seasonal = "Seasonal ingredients"
    case quickMeal = "Quick to prepare"
    case budgetFriendly = "Budget friendly"
    
    var icon: String {
        switch self {
        case .expiringIngredients: return "clock.badge.exclamationmark"
        case .nutritionGoals: return "chart.line.uptrend.xyaxis"
        case .dietaryPreference: return "leaf.fill"
        case .popularRecipe: return "star.fill"
        case .seasonal: return "sun.max.fill"
        case .quickMeal: return "bolt.fill"
        case .budgetFriendly: return "dollarsign.circle.fill"
        }
    }
}

// MARK: - Recipe Suggestion Model
struct RecipeSuggestion: Identifiable, Codable, Equatable {
    let id: UUID
    var recipe: Recipe
    var reason: SuggestionReason
    var customMessage: String?
    var confidence: Double // 0.0 to 1.0
    var expiringItems: [Item]
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        recipe: Recipe,
        reason: SuggestionReason,
        customMessage: String? = nil,
        confidence: Double = 0.5,
        expiringItems: [Item] = [],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.recipe = recipe
        self.reason = reason
        self.customMessage = customMessage
        self.confidence = min(max(confidence, 0.0), 1.0) // Clamp between 0 and 1
        self.expiringItems = expiringItems
        self.timestamp = timestamp
    }
    
    // MARK: - Computed Properties
    var displayMessage: String {
        customMessage ?? reason.rawValue
    }
    
    var isHighConfidence: Bool {
        confidence >= 0.7
    }
}
