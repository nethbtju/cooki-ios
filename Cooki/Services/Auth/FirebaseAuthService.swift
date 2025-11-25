//
//  FirebaseAuthService.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    // MARK: - Sign Up (Step 1: Create Firebase Auth account only)
    func signUp(email: String, password: String) async throws -> User {
        do {
            // Create Firebase Auth user
            let authResult = try await auth.createUser(withEmail: email, password: password)
            let firebaseUser = authResult.user
            
            // Create minimal User model (no Firestore doc yet)
            let user = User(
                id: UUID(uuidString: firebaseUser.uid) ?? UUID(),
                displayName: "", // Empty - will be set in UserDetailsView
                email: email,
                profileImageName: nil,
                pantryIds: [], // Will be created in completeUserRegistration
                createdAt: Date(),
                preferences: User.UserPreferences()
            )
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: Auth account created")
                print("   Email: \(email)")
                print("   UID: \(firebaseUser.uid)")
                print("   ⚠️ Firestore document NOT created yet")
                print("   → User must complete profile in UserDetailsView")
            }
            
            return user
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Sign up failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Complete User Registration (Step 2: Create Firestore doc + pantry)
    func completeUserRegistration(displayName: String, preferences: User.UserPreferences) async throws -> User {
        guard let firebaseUser = auth.currentUser else {
            throw AuthServiceError.notAuthenticated
        }
        
        do {
            let userId = UUID(uuidString: firebaseUser.uid) ?? UUID()
            
            // 1. Create empty pantry for user
            let pantry = Pantry(
                name: "\(displayName)'s Pantry",
                memberIds: [userId]
            )
            
            // Store pantry in Firestore
            let pantryRef = db.collection("pantries").document(pantry.id.uuidString)
            try await pantryRef.setData([
                "id": pantry.id.uuidString,
                "name": pantry.name,
                "items": [], // Empty array
                "memberIds": [userId.uuidString],
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
            ])
            
            // 2. Create complete user object
            let user = User(
                id: userId,
                displayName: displayName,
                email: firebaseUser.email ?? "",
                profileImageName: nil,
                pantryIds: [pantry.id],
                createdAt: Date(),
                preferences: preferences
            )
            
            // 3. Create user document in Firestore
            try await createUserDocument(user: user, firebaseUID: firebaseUser.uid)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: User registration completed")
                print("   User ID: \(user.id)")
                print("   Name: \(user.displayName)")
                print("   Pantry ID: \(pantry.id)")
                print("   Dietary Prefs: \(preferences.dietaryPreferences.map { $0.rawValue })")
            }
            
            return user
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Failed to complete registration - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let firebaseUser = authResult.user
            
            // Fetch user data from Firestore
            let user = try await fetchUserDocument(firebaseUID: firebaseUser.uid)
            
            // Check if user completed profile
            if !user.hasCompletedProfile {
                throw AuthServiceError.profileIncomplete
            }
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: User signed in successfully")
                print("   Email: \(email)")
                print("   UID: \(firebaseUser.uid)")
                print("   Pantry IDs: \(user.pantryIds)")
            }
            
            return user
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Sign in failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        do {
            try auth.signOut()
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: User signed out")
            }
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Sign out failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Get Current User
    func getCurrentUser() -> User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        
        // Return nil to force async fetch
        return nil
    }
    
    // MARK: - Update Profile
    func updateProfile(user: User) async throws {
        guard let firebaseUser = auth.currentUser else {
            throw AuthServiceError.notAuthenticated
        }
        
        do {
            let userRef = db.collection("users").document(firebaseUser.uid)
            
            let userData: [String: Any] = [
                "displayName": user.displayName,
                "email": user.email,
                "profileImageName": user.profileImageName as Any,
                "pantryIds": user.pantryIds.map { $0.uuidString },
                "updatedAt": FieldValue.serverTimestamp()
            ]
            
            try await userRef.updateData(userData)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: Profile updated")
            }
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Profile update failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount() async throws {
        guard let firebaseUser = auth.currentUser else {
            throw AuthServiceError.notAuthenticated
        }
        
        do {
            let uid = firebaseUser.uid
            
            // Delete Firestore document (if exists)
            try? await db.collection("users").document(uid).delete()
            
            // Delete Firebase Auth user
            try await firebaseUser.delete()
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: Account deleted")
            }
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Account deletion failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: Password reset email sent to \(email)")
            }
            
        } catch let error as NSError {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseAuthService: Password reset failed - \(error.localizedDescription)")
            }
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createUserDocument(user: User, firebaseUID: String) async throws {
        let userRef = db.collection("users").document(firebaseUID)
        
        let userData: [String: Any] = [
            "id": user.id.uuidString,
            "displayName": user.displayName,
            "email": user.email,
            "profileImageName": user.profileImageName as Any,
            "pantryIds": user.pantryIds.map { $0.uuidString },
            "createdAt": FieldValue.serverTimestamp(),
            "preferences": [
                "dietaryPreferences": user.preferences.dietaryPreferences.map { $0.rawValue },
                "allergies": user.preferences.allergies,
                "dislikedIngredients": user.preferences.dislikedIngredients,
                "servingsPerMeal": user.preferences.servingsPerMeal,
                "notificationsEnabled": user.preferences.notificationsEnabled
            ]
        ]
        
        try await userRef.setData(userData)
    }
    
    private func fetchUserDocument(firebaseUID: String) async throws -> User {
        let userRef = db.collection("users").document(firebaseUID)
        let snapshot = try await userRef.getDocument()
        
        guard let data = snapshot.data() else {
            // User authenticated but no Firestore doc = incomplete profile
            throw AuthServiceError.profileIncomplete
        }
        
        // Parse pantry IDs
        let pantryIdStrings = data["pantryIds"] as? [String] ?? []
        let pantryIds = pantryIdStrings.compactMap { UUID(uuidString: $0) }
        
        // Parse user data
        let user = User(
            id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
            displayName: data["displayName"] as? String ?? "",
            email: data["email"] as? String ?? "",
            profileImageName: data["profileImageName"] as? String,
            pantryIds: pantryIds,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            preferences: parsePreferences(data["preferences"] as? [String: Any])
        )
        
        return user
    }
    
    private func parsePreferences(_ data: [String: Any]?) -> User.UserPreferences {
        guard let data = data else {
            return User.UserPreferences()
        }
        
        let dietaryPrefs = (data["dietaryPreferences"] as? [String] ?? [])
            .compactMap { DietaryPreference(rawValue: $0) }
        
        return User.UserPreferences(
            dietaryPreferences: dietaryPrefs,
            allergies: data["allergies"] as? [String] ?? [],
            dislikedIngredients: data["dislikedIngredients"] as? [String] ?? [],
            servingsPerMeal: data["servingsPerMeal"] as? Int ?? 2,
            notificationsEnabled: data["notificationsEnabled"] as? Bool ?? true
        )
    }
    
    private func mapFirebaseError(_ error: NSError) -> AuthServiceError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknownError(error.localizedDescription)
        }
        
        switch errorCode {
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmail
        case .weakPassword:
            return .weakPassword
        case .wrongPassword, .userNotFound:
            return .invalidCredentials
        case .networkError:
            return .networkError
        case .userDisabled:
            return .accountDisabled
        default:
            return .unknownError(error.localizedDescription)
        }
    }
}
