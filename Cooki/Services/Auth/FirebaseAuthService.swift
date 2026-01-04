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
    private let pantryService: PantryServiceProtocol
    
    // MARK: - Init
    init(pantryService: PantryServiceProtocol = ServiceFactory.shared.makePantryService()) {
        self.pantryService = pantryService
    }
    
    // MARK: - Sign Up (Step 1: Create Firebase Auth account only)
    func signUp(email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            let firebaseUser = authResult.user
            
            let user = User(
                id: firebaseUser.uid,
                displayName: "",
                email: email,
                profileImageName: nil,
                pantryIds: [],
                createdAt: Date(),
                preferences: User.UserPreferences()
            )
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: Auth account created")
                print("   Email: \(email)")
                print("   Firebase UID: \(firebaseUser.uid)")
                print("   User ID: \(user.id)")
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
    
    // MARK: - Complete User Registration
    func completeUserRegistration(displayName: String, preferences: User.UserPreferences) async throws -> User {
        guard let firebaseUser = auth.currentUser else {
            throw AuthServiceError.notAuthenticated
        }
        
        do {
            let userId = firebaseUser.uid
            
            let pantry = try await pantryService.createPantry(
                name: "\(displayName)'s Pantry",
                memberIds: [userId]
            )
            
            let user = User(
                id: userId,
                displayName: displayName,
                email: firebaseUser.email ?? "",
                profileImageName: nil,
                pantryIds: [pantry.id.uuidString],
                createdAt: Date(),
                preferences: preferences
            )
            
            try await createUserDocument(user: user, firebaseUID: userId)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseAuthService: User registration completed")
                print("   Firebase UID: \(firebaseUser.uid)")
                print("   User ID: \(user.id)")
                print("   Name: \(user.displayName)")
                print("   Pantry ID: \(pantry.id)")
                print("   Pantry Members: \(pantry.memberIds)")
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
            
            let user = try await fetchUserDocument(firebaseUID: firebaseUser.uid)
            
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
            
        } catch let authError as AuthServiceError {
            if AppConfig.enableDebugLogging {
                print("⚠️ FirebaseAuthService: Auth service error - \(authError.localizedDescription)")
            }
            throw authError
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
        guard auth.currentUser != nil else { return nil }
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
                "pantryIds": user.pantryIds, // ✅ fixed
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
            try? await db.collection("users").document(uid).delete()
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
            "id": user.id,
            "displayName": user.displayName,
            "email": user.email,
            "profileImageName": user.profileImageName as Any,
            "pantryIds": user.pantryIds, // ✅ fixed
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
            throw AuthServiceError.profileIncomplete
        }
        
        let pantryIds = data["pantryIds"] as? [String] ?? [] // ✅ fixed
        
        let user = User(
            id: data["id"] as? String ?? firebaseUID,
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
