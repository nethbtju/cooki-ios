//
//  MockAuthService.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

class MockAuthService: AuthServiceProtocol {

    // MARK: - Properties
    private var currentUser: User?
    private var mockUsers: [String: (password: String, user: User)] = [:]
    
    init() {
        // Pre-populate with mock user
        let mockUser = User.mock
        mockUsers[mockUser.email] = (password: "password123", user: mockUser)
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if AppConfig.enableDebugLogging {
            print("🔐 MockAuthService: Attempting sign up...")
            print("   Email: \(email)")
        }
        
        // Check if user already exists
        if mockUsers[email] != nil {
            throw AuthServiceError.emailAlreadyInUse
        }
        
        // Validate password
        if password.count < 6 {
            throw AuthServiceError.weakPassword
        }
        
        // Create new user
        let user = User(
            email: email
        )
        
        // Store user
        mockUsers[email] = (password: password, user: user)
        currentUser = user
        
        if AppConfig.enableDebugLogging {
            print("✅ MockAuthService: Sign up successful")
            print("   User: \(user.displayName)")
        }
        
        return user
    }
    
    func completeUserRegistration(displayName: String, preferences: User.UserPreferences) async throws -> User {
        guard var user = currentUser else {
            throw AuthServiceError.notAuthenticated
        }
        
        user.displayName = displayName
        user.preferences = preferences
        
        // Create mock pantry
        let pantryId = ""
        user.pantryIds = [pantryId]
        
        currentUser = user
        
        if let userData = mockUsers[user.email] {
            mockUsers[user.email] = (password: userData.password, user: user)
        }
        
        return user
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if AppConfig.enableDebugLogging {
            print("🔐 MockAuthService: Attempting sign in...")
            print("   Email: \(email)")
        }
        
        // Check if user exists
        guard let userData = mockUsers[email] else {
            throw AuthServiceError.userNotFound
        }
        
        // Verify password
        if userData.password != password {
            throw AuthServiceError.invalidCredentials
        }
        
        // Set current user
        currentUser = userData.user
        
        if AppConfig.enableDebugLogging {
            print("✅ MockAuthService: Sign in successful")
            print("   User: \(userData.user.displayName)")
        }
        
        return userData.user
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        if AppConfig.enableDebugLogging {
            print("👋 MockAuthService: Signing out")
        }
        currentUser = nil
    }
    
    // MARK: - Get Current User
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    // MARK: - Update Profile
    func updateProfile(user: User) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if AppConfig.enableDebugLogging {
            print("✅ MockAuthService: Updating profile")
            print("   Name: \(user.displayName)")
        }
        
        // Update stored user
        if let userData = mockUsers[user.email] {
            mockUsers[user.email] = (password: userData.password, user: user)
        }
        
        currentUser = user
    }
    
    // MARK: - Delete Account
    func deleteAccount() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if AppConfig.enableDebugLogging {
            print("🗑️ MockAuthService: Deleting account")
        }
        
        if let user = currentUser {
            mockUsers.removeValue(forKey: user.email)
        }
        
        currentUser = nil
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if AppConfig.enableDebugLogging {
            print("📧 MockAuthService: Password reset email sent to \(email)")
        }
        
        // Check if user exists
        guard mockUsers[email] != nil else {
            throw AuthServiceError.userNotFound
        }
    }
}
