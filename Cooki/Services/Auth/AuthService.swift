//
//  AuthService.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    /// Sign up a new user
    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> User
    
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
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "No account found with this email"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .networkError:
            return "Network connection failed"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
