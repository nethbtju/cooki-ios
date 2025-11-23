//
//  AppViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//  Modified by Neth Botheju on 23/11/2025.
//
import Foundation
import SwiftUI
import FirebaseAuth

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
    
    // MARK: - Auth State Listener Handle
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    init() {
        self.authService = ServiceFactory.shared.makeAuthService()
        self.userService = ServiceFactory.shared.makeUserService()
        
        // Set up Firebase auth state listener
        setupAuthStateListener()
    }
    
    deinit {
        // Remove auth state listener when view model is deallocated
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Auth State Listener
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if user != nil {
                    // User is signed in, fetch user data
                    await self.fetchCurrentUser()
                } else {
                    // User is signed out
                    self.currentUser = nil
                    self.isAuthenticated = false
                    
                    if AppConfig.enableDebugLogging {
                        print("🔐 AppViewModel: User signed out")
                    }
                }
            }
        }
        
        if AppConfig.enableDebugLogging {
            print("🔐 AppViewModel: Auth state listener setup")
        }
    }
    
    private func fetchCurrentUser() async {
        do {
            let user = try await userService.fetchUserProfile()
            self.currentUser = user
            self.isAuthenticated = true
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Current user fetched")
                print("   User: \(user.fullName)")
            }
        } catch {
            self.isAuthenticated = false
            
            if AppConfig.enableDebugLogging {
                print("❌ AppViewModel: Failed to fetch current user - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(
                email: email,
                password: password,
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

    // MARK: - Complete User Registration
    func completeUserRegistration(firstName: String, preferences: User.UserPreferences) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let completedUser = try await authService.completeUserRegistration(
                firstName: firstName,
                preferences: preferences
            )
            self.currentUser = completedUser
            self.isAuthenticated = true
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: User registration completed")
                print("   Name: \(completedUser.fullName)")
                print("   Pantry IDs: \(completedUser.pantryIds)")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            
            if AppConfig.enableDebugLogging {
                print("❌ AppViewModel: Failed to complete registration - \(error.localizedDescription)")
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
    func signOut() async {
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
            let imageUrl = try await userService.uploadProfileImage(imageData)
            
            if var user = currentUser {
                user.profileImageName = imageUrl
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
