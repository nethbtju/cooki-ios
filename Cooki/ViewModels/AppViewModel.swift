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
    
    // New property to track if user needs to complete profile
    @Published var needsProfileCompletion = false
    
    // MARK: - Services
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - Auth State Listener Handle
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // Flag to prevent fetching during registration flow
    private var isRegistering = false
    
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
                    // User is signed in
                    // Don't fetch if we're in the middle of registration
                    if !self.isRegistering && !self.needsProfileCompletion {
                        await self.fetchCurrentUser()
                    } else {
                        if AppConfig.enableDebugLogging {
                            print("🔐 AppViewModel: Auth state changed but user is registering/completing profile, skipping fetch")
                        }
                    }
                } else {
                    // User is signed out
                    self.currentUser = nil
                    self.isAuthenticated = false
                    self.needsProfileCompletion = false
                    self.isRegistering = false
                    
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
            
            // Only update if we're not in the middle of registration
            // (to prevent overwriting the state we just set in signUp)
            if !needsProfileCompletion || !user.displayName.isEmpty {
                self.currentUser = user
                
                // Check if user has completed their profile
                let hasCompletedProfile = !user.displayName.isEmpty && !user.pantryIds.isEmpty
                
                if hasCompletedProfile {
                    // User has completed profile, fully authenticated
                    self.isAuthenticated = true
                    self.needsProfileCompletion = false
                    
                    if AppConfig.enableDebugLogging {
                        print("✅ AppViewModel: Current user fetched (Profile Complete)")
                        print("   User: \(user.displayName)")
                        print("   Pantries: \(user.pantryIds.count)")
                    }
                } else {
                    // User exists but hasn't completed profile
                    self.isAuthenticated = true
                    self.needsProfileCompletion = true
                    
                    if AppConfig.enableDebugLogging {
                        print("⚠️ AppViewModel: Current user fetched (Profile Incomplete)")
                        print("   Email: \(user.email)")
                        print("   Needs profile completion")
                    }
                }
            }
        } catch {
            // If fetch fails during registration, keep the registration state
            if !needsProfileCompletion {
                self.isAuthenticated = false
                self.needsProfileCompletion = false
            }
            
            if AppConfig.enableDebugLogging {
                print("⚠️ AppViewModel: Failed to fetch user (might be during registration) - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        isRegistering = true // Set flag to prevent auth listener from fetching
        
        do {
            // Create Firebase Auth user (this does NOT create Firestore document yet)
            let user = try await authService.signUp(
                email: email,
                password: password
            )
            
            // Immediately set the state before auth listener fires
            currentUser = user
            isAuthenticated = true
            needsProfileCompletion = true // New users need to complete profile
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Sign up successful")
                print("   Email: \(email)")
                print("   User ID: \(user.id)")
                print("   isAuthenticated: \(isAuthenticated)")
                print("   needsProfileCompletion: \(needsProfileCompletion)")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isAuthenticated = false
            needsProfileCompletion = false
            isRegistering = false
            
            if AppConfig.enableDebugLogging {
                print("❌ AppViewModel: Sign up failed - \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }

    // MARK: - Complete User Registration
    func completeUserRegistration(displayName: String, preferences: User.UserPreferences) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let completedUser = try await authService.completeUserRegistration(
                displayName: displayName,
                preferences: preferences
            )
            
            self.currentUser = completedUser
            self.isAuthenticated = true
            self.needsProfileCompletion = false // Profile is now complete
            self.isRegistering = false // Registration flow complete
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: User registration completed")
                print("   Name: \(completedUser.displayName)")
                print("   Pantry IDs: \(completedUser.pantryIds)")
                print("   Profile complete: true")
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
            
            // Check if user has completed their profile
            let hasCompletedProfile = !user.displayName.isEmpty && !user.pantryIds.isEmpty
            
            isAuthenticated = true
            needsProfileCompletion = !hasCompletedProfile
            
            if AppConfig.enableDebugLogging {
                print("✅ AppViewModel: Sign in successful")
                print("   User: \(user.displayName.isEmpty ? user.email : user.displayName)")
                print("   Profile complete: \(hasCompletedProfile)")
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isAuthenticated = false
            needsProfileCompletion = false
            
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
            needsProfileCompletion = false
            
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
            needsProfileCompletion = false
            
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
