//
//  User.swift
//  Cooki
//
//  Modified by Neth Botheju on 23/11/2025.
//
import Foundation
import SwiftUI

// MARK: - User Model
struct User: Identifiable, Codable, Equatable {
    let id: String // Changed from UUID to String to match Firebase Auth UID
    var displayName: String
    var email: String
    var profileImageName: String?
    var pantryIds: [String]
    var createdAt: Date
    var preferences: UserPreferences
    
    init(
        id: String = UUID().uuidString, // Default to UUID string for compatibility
        displayName: String = "",
        email: String,
        profileImageName: String? = nil,
        pantryIds: [String] = [],
        createdAt: Date = Date(),
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.profileImageName = profileImageName
        self.pantryIds = pantryIds
        self.createdAt = createdAt
        self.preferences = preferences
    }
    
    
    var greeting: String {
        displayName.isEmpty ? "Hello" : "Hello, \(displayName)"
    }
    
    // Profile picture with automatic fallback to initials
    func getProfilePicture(size: CGFloat = 40) -> some View {
        Group {
            if let profileImageName = profileImageName {
                Image(profileImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                // Fallback to initials
                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Text(initials)
                            .font(.system(size: size * 0.4, weight: .semibold))
                            .foregroundColor(.purple)
                    )
            }
        }
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

// MARK: - User Preferences
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
        
        var isVegetarian: Bool {
            dietaryPreferences.contains(.vegetarian)
        }
        
        var isVegan: Bool {
            dietaryPreferences.contains(.vegan)
        }
    }
}
