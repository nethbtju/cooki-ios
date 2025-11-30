//
//  FirebaseUserService.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FirebaseUserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    // MARK: - Fetch User Profile
    func fetchUserProfile() async throws -> User {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw UserServiceError.userNotFound
        }
        
        do {
            let userRef = db.collection("users").document(firebaseUser.uid)
            let snapshot = try await userRef.getDocument()
            
            guard let data = snapshot.data() else {
                throw UserServiceError.userNotFound
            }
            
            let user = User(
                id: firebaseUser.uid,
                displayName: data["displayName"] as? String ?? "",
                email: data["email"] as? String ?? "",
                profileImageName: data["profileImageName"] as? String,
                pantryIds: data["pantryId"] as? [UUID] ?? [],
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                preferences: parsePreferences(data["preferences"] as? [String: Any])
            )
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseUserService: User profile fetched")
            }
            
            return user
            
        } catch {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseUserService: Failed to fetch profile - \(error.localizedDescription)")
            }
            throw UserServiceError.userNotFound
        }
    }
    
    // MARK: - Update User Profile
    func updateUserProfile(_ user: User) async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw UserServiceError.userNotFound
        }
        
        do {
            let userRef = db.collection("users").document(firebaseUser.uid)
            
            let userData: [String: Any] = [
                "displayName": user.displayName,
                "email": user.email,
                "profileImageName": user.profileImageName as Any,
                "updatedAt": FieldValue.serverTimestamp(),
                "preferences": [
                    "dietaryPreferences": user.preferences.dietaryPreferences.map { $0.rawValue },
                    "allergies": user.preferences.allergies,
                    "dislikedIngredients": user.preferences.dislikedIngredients,
                    "servingsPerMeal": user.preferences.servingsPerMeal,
                    "notificationsEnabled": user.preferences.notificationsEnabled
                ]
            ]
            
            try await userRef.updateData(userData)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseUserService: User profile updated")
            }
            
        } catch {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseUserService: Failed to update profile - \(error.localizedDescription)")
            }
            throw UserServiceError.updateFailed
        }
    }
    
    // MARK: - Upload Profile Image
    func uploadProfileImage(_ imageData: Data) async throws -> String {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw UserServiceError.userNotFound
        }
        
        // Compress image
        guard let image = UIImage(data: imageData),
              let compressed = image.compressForStorage() else {
            throw UserServiceError.invalidImageData
        }
        
        // Check size (200 KB max for free tier)
        guard compressed.count <= 200_000 else {
            throw UserServiceError.invalidImageData
        }
        
        do {
            let storageRef = storage.reference()
            let fileName = "profile_\(UUID().uuidString).jpg"
            let fileRef = storageRef.child("profile-images/\(firebaseUser.uid)/\(fileName)")
            
            // Upload
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            _ = try await fileRef.putDataAsync(compressed, metadata: metadata)
            
            // Get download URL
            let downloadURL = try await fileRef.downloadURL()
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseUserService: Profile image uploaded")
                print("   Size: \(compressed.count) bytes")
                print("   URL: \(downloadURL.absoluteString)")
            }
            
            return downloadURL.absoluteString
            
        } catch {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseUserService: Failed to upload image - \(error.localizedDescription)")
            }
            throw UserServiceError.uploadFailed
        }
    }
    
    // MARK: - Update Preferences
    func updatePreferences(_ preferences: User.UserPreferences) async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw UserServiceError.userNotFound
        }
        
        do {
            let userRef = db.collection("users").document(firebaseUser.uid)
            
            let preferencesData: [String: Any] = [
                "preferences": [
                    "dietaryPreferences": preferences.dietaryPreferences.map { $0.rawValue },
                    "allergies": preferences.allergies,
                    "dislikedIngredients": preferences.dislikedIngredients,
                    "servingsPerMeal": preferences.servingsPerMeal,
                    "notificationsEnabled": preferences.notificationsEnabled
                ],
                "updatedAt": FieldValue.serverTimestamp()
            ]
            
            try await userRef.updateData(preferencesData)
            
            if AppConfig.enableDebugLogging {
                print("✅ FirebaseUserService: Preferences updated")
            }
            
        } catch {
            if AppConfig.enableDebugLogging {
                print("❌ FirebaseUserService: Failed to update preferences - \(error.localizedDescription)")
            }
            throw UserServiceError.updateFailed
        }
    }
    
    // MARK: - Helper Methods
    
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
}

// MARK: - UIImage Extension for Compression
extension UIImage {
    func compressForStorage() -> Data? {
        // Resize to reasonable dimensions (max 800x800 for profile pic)
        let maxDimension: CGFloat = 800
        let scale = min(maxDimension / size.width, maxDimension / size.height, 1.0)
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Compress to JPEG (0.7 quality is good balance)
        guard let imageData = resized?.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        // If still too large, reduce quality further
        if imageData.count > 200_000 {
            return resized?.jpegData(compressionQuality: 0.5)
        }
        
        return imageData
    }
}
