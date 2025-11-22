//
//  AppViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Services
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - Init
    init(
        authService: AuthServiceProtocol? = nil,
        userService: UserServiceProtocol? = nil
    ) {
        self.authService = authService ?? ServiceFactory.shared.makeAuthService()
        self.userService = userService ?? ServiceFactory.shared.makeUserService()
        
        // Check if user is already logged in
        checkAuthState()
    }
    
    // MARK: - Auth State
    private func checkAuthState() {
        currentUser = authService.getCurrentUser()
        isAuthenticated = currentUser != nil
        
        if AppConfig.enableDebugLogging {
            print("🔐 AppViewModel: Auth state checked")
            print("   Authenticated: \(isAuthenticated)")
            if let user = currentUser {
                print("   User: \(user.fullName)")
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, firstName: String, lastName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            currentUser = user
            isAuthenticated = true
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Sign up successful")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            
            if AppConfig.enableDebugLogging {
                print("❌ AppViewModel: Sign up failed - \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Sign in successful")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            
            if AppConfig.enableDebugLogging {
                print("❌ AppViewModel: Sign in failed - \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
            isAuthenticated = false
            
            if AppConfig.enableDebugLogging {
                print("👋 AppViewModel: Sign out successful")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Update Profile
    func updateProfile(_ user: User) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.updateProfile(user: user)
            currentUser = user
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Profile updated")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Upload Profile Image
    func uploadProfileImage(_ imageData: Data) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let imageName = try await userService.uploadProfileImage(imageData)
            
            if var user = currentUser {
                user.profileImageName = imageName
                try await authService.updateProfile(user: user)
                currentUser = user
                
                if AppConfig.enableDebugLogging {
                    print("✅ AppViewModel: Profile image uploaded")
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Update Preferences
    func updatePreferences(_ preferences: User.UserPreferences) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await userService.updatePreferences(preferences)
            
            if var user = currentUser {
                user.preferences = preferences
                currentUser = user
                
                if AppConfig.enableDebugLogging {
                    print("✅ AppViewModel: Preferences updated")
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Delete Account
    func deleteAccount() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.deleteAccount()
            currentUser = nil
            isAuthenticated = false
            
            if AppConfig.enableDebugLogging {
                print("🗑️ AppViewModel: Account deleted")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: email)
            
            if AppConfig.enableDebugLogging {
                print("📧 AppViewModel: Password reset email sent")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
}
