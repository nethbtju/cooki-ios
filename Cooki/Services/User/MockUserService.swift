//
//  MockUserService.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

class MockUserService: UserServiceProtocol {
    
    // MARK: - Fetch Profile
    func fetchUserProfile() async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if AppConfig.enableDebugLogging {
            print("📱 MockUserService: Fetching user profile...")
        }
        
        return User.mock
    }
    
    // MARK: - Update Profile
    func updateUserProfile(_ user: User) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if AppConfig.enableDebugLogging {
            print("✅ MockUserService: Updated user profile")
            print("   Name: \(user.fullName)")
            print("   Email: \(user.email)")
        }
    }
    
    // MARK: - Upload Profile Image
    func uploadProfileImage(_ imageData: Data) async throws -> String {
        // Validate image size
        if imageData.count > AppConfig.maxImageUploadSize {
            throw UserServiceError.invalidImageData
        }
        
        // Simulate upload delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let imageName = "profile_\(UUID().uuidString).jpg"
        
        if AppConfig.enableDebugLogging {
            print("✅ MockUserService: Uploaded profile image")
            print("   Image name: \(imageName)")
            print("   Size: \(imageData.count / 1024)KB")
        }
        
        return imageName
    }
    
    // MARK: - Update Preferences
    func updatePreferences(_ preferences: User.UserPreferences) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        if AppConfig.enableDebugLogging {
            print("✅ MockUserService: Updated preferences")
            print("   Dietary: \(preferences.dietaryPreferences.map { $0.rawValue })")
            print("   Servings: \(preferences.servingsPerMeal)")
        }
    }
}
