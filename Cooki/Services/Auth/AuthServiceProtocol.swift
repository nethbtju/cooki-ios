//
//  AuthServiceProtocol.swift
//  Cooki
//
//  Modified by Neth Botheju on 23/11/2025.
//
import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    /// Sign up a new user (creates Firebase Auth account only, no Firestore doc)
    func signUp(email: String, password: String) async throws -> User
    
    /// Complete user registration with name and preferences (creates Firestore doc + pantry)
    func completeUserRegistration(firstName: String, preferences: User.UserPreferences) async throws -> User
    
    /// Sign in an existing user
    func signIn(email: String, password: String) async throws -> User
    
    /// Sign out the current user
    func signOut() throws
    
    /// Get the currently authenticated user
    func getCurrentUser() -> User?
    
    /// Update user profile
    func updateProfile(user: User) async throws
    
    /// Delete user account
    func deleteAccount() async throws
    
    /// Reset password
    func resetPassword(email: String) async throws
}

// MARK: - Auth Service Errors
enum AuthServiceError: LocalizedError {
    case invalidEmail
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case accountDisabled
    case notAuthenticated
    case profileIncomplete
    case userNotFound
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .networkError:
            return "Network error. Please check your connection"
        case .accountDisabled:
            return "This account has been disabled"
        case .notAuthenticated:
            return "You must be signed in to perform this action"
        case .profileIncomplete:
            return "Please complete your profile to continue"
        case .userNotFound:
            return "User not found. Please register"
        case .unknownError(let message):
            return message
        }
    }
}
