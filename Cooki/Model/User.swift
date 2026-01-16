//
//  User.swift
//  Cooki
//
//  Modified by Neth Botheju on 23/11/2025.
//  Updated by Rohit Valanki on 11/01/2026
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable, Equatable {
    let id: String // Firebase UID
    var displayName: String
    var email: String
    var profileImageName: String?
    var pantryIds: [String]
    var currentPantryId: String?
    var createdAt: Date
    var preferences: UserPreferences
    
    var uid: String { id } // NEW: convenience for Firebase auth UID
    
    init(
        id: String = UUID().uuidString,
        displayName: String = "",
        email: String,
        profileImageName: String? = nil,
        pantryIds: [String] = [],
        currentPantryId: String? = nil,
        createdAt: Date = Date(),
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.profileImageName = profileImageName
        self.pantryIds = pantryIds
        self.currentPantryId = currentPantryId
        self.createdAt = createdAt
        self.preferences = preferences
    }
    
    var greeting: String {
        displayName.isEmpty ? "Hello" : "Hello, \(displayName)"
    }
    
    // Profile picture with automatic fallback to initials
    var profilePicture: Image {
            Image(profileImageName ?? "ProfilePic") // TODO: ADD PLACEHOLDER IMAGE HERE
        }
    
    
    // Get user initials for fallback
        var initials: String {
            let components = displayName.components(separatedBy: " ")
            let firstInitial = components.first?.first.map(String.init) ?? ""
            let lastInitial = components.count > 1 ? components.last?.first.map(String.init) ?? "" : ""
            let combined = firstInitial + lastInitial
            return combined.isEmpty ? String(email.prefix(1)).uppercased() : combined.uppercased()
        }
        
        // Check if user has completed onboarding
        var hasCompletedProfile: Bool {
            !displayName.isEmpty
        }
}

extension User {
    struct UserPreferences: Codable, Equatable {
        var dietaryPreferences: [DietaryPreference]
        var allergies: [String]
        var dislikedIngredients: [String]
        var servingsPerMeal: Int
        var notificationsEnabled: Bool
        
        init(
            dietaryPreferences: [DietaryPreference] = [],
            allergies: [String] = [],
            dislikedIngredients: [String] = [],
            servingsPerMeal: Int = 2,
            notificationsEnabled: Bool = true
        ) {
            self.dietaryPreferences = dietaryPreferences
            self.allergies = allergies
            self.dislikedIngredients = dislikedIngredients
            self.servingsPerMeal = servingsPerMeal
            self.notificationsEnabled = notificationsEnabled
        }
        
        var isVegetarian: Bool { dietaryPreferences.contains(.vegetarian) }
        var isVegan: Bool { dietaryPreferences.contains(.vegan) }
    }
}
