//
//  ProfileViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var preferences: User.UserPreferences
    @Published var showImagePicker = false
    @Published var showDeleteConfirmation = false
    
    // MARK: - App View Model
    private let appViewModel: AppViewModel
    
    // MARK: - Init
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        
        // Initialize with current user data
        if let user = appViewModel.currentUser {
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.email = user.email
            self.preferences = user.preferences
        } else {
            self.preferences = User.UserPreferences()
        }
    }
    
    // MARK: - Computed Properties
    var hasChanges: Bool {
        guard let currentUser = appViewModel.currentUser else { return false }
        
        return firstName != currentUser.firstName ||
               lastName != currentUser.lastName ||
               preferences != currentUser.preferences
    }
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty
    }
    
    // MARK: - Actions
    func saveProfile() async {
        guard let currentUser = appViewModel.currentUser else { return }
        
        var updatedUser = currentUser
        updatedUser.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedUser.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedUser.preferences = preferences
        
        await appViewModel.updateProfile(updatedUser)
    }
    
    func uploadProfileImage(_ imageData: Data) async {
        await appViewModel.uploadProfileImage(imageData)
    }
    
    func updatePreferences() async {
        await appViewModel.updatePreferences(preferences)
    }
    
    func signOut() async {
        await appViewModel.signOut()
    }
    
    func deleteAccount() async {
        await appViewModel.deleteAccount()
    }
    
    // MARK: - Preference Helpers
    func toggleDietaryPreference(_ preference: DietaryPreference) {
        if preferences.dietaryPreferences.contains(preference) {
            preferences.dietaryPreferences.removeAll { $0 == preference }
        } else {
            preferences.dietaryPreferences.append(preference)
        }
    }
    
    func isDietaryPreferenceSelected(_ preference: DietaryPreference) -> Bool {
        preferences.dietaryPreferences.contains(preference)
    }
    
    func addAllergy(_ allergy: String) {
        let trimmed = allergy.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !preferences.allergies.contains(trimmed) {
            preferences.allergies.append(trimmed)
        }
    }
    
    func removeAllergy(_ allergy: String) {
        preferences.allergies.removeAll { $0 == allergy }
    }
}
