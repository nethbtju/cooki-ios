//
//  UserService.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - User Service Protocol
protocol UserServiceProtocol {
    /// Fetch the current user's profile
    func fetchUserProfile() async throws -> User
    
    /// Update user profile information
    func updateUserProfile(_ user: User) async throws
    
    /// Upload profile image and return the image name/URL
    func uploadProfileImage(_ imageData: Data) async throws -> String
    
    /// Update user preferences
    func updatePreferences(_ preferences: User.UserPreferences) async throws
}

// MARK: - User Service Errors
enum UserServiceError: LocalizedError {
    case userNotFound
    case invalidImageData
    case uploadFailed
    case updateFailed
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User profile not found"
        case .invalidImageData:
            return "Invalid image data. Max size is 5MB"
        case .uploadFailed:
            return "Failed to upload profile image"
        case .updateFailed:
            return "Failed to update profile"
        }
    }
}
