//
//  User.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation
import SwiftUI

// MARK: - User Model
struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var profileImageName: String?
    var createdAt: Date
    var preferences: UserPreferences
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        email: String,
        profileImageName: String? = nil,
        createdAt: Date = Date(),
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImageName = profileImageName
        self.createdAt = createdAt
        self.preferences = preferences
    }
    
    // MARK: - Computed Properties
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var greeting: String {
        "Hello, \(firstName)"
    }
    
    var getProfilePicture: Image {
        Image(profileImageName ?? "ProfilePic") // TODO: Add a default user profile image
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
