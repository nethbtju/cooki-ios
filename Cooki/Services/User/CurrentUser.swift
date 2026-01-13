//
//  CurrentUser.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/12/2025.
//  Updated by Rohit Valanki on 11/01/2026
//

import SwiftUI

@MainActor
class CurrentUser: ObservableObject {

    @Published var user: User? {
        didSet {
            // Auto-select pantry from user's currentPantryId if available
            if let savedPantryId = user?.currentPantryId {
                currentPantryId = savedPantryId
                print("🧺 Current pantry restored from user:", savedPantryId)
            }
            // If no current pantry is set, fallback to first pantry in the list
            else if let firstPantry = user?.pantryIds.first {
                currentPantryId = firstPantry
                print("🧺 Default pantry selected:", firstPantry)
            }
        }
    }

    @Published var currentPantryId: String?

    // Singleton
    static let shared = CurrentUser()
    private init() {}

    // MARK: - Pantry Selection
    func setCurrentPantry(byId pantryId: String) {
        guard let oldUser = user, oldUser.pantryIds.contains(pantryId) else {
            print("⚠️ Pantry ID not found in user's pantries")
            return
        }
        currentPantryId = pantryId
        user = User(
            id: oldUser.id,
            displayName: oldUser.displayName,
            email: oldUser.email,
            profileImageName: oldUser.profileImageName,
            pantryIds: oldUser.pantryIds,
            currentPantryId: pantryId,
            createdAt: oldUser.createdAt,
            preferences: oldUser.preferences
        )
        print("✅ Current pantry updated:", pantryId)
    }

    func setCurrentPantry(byIndex index: Int) {
        guard let oldUser = user,
              index >= 0,
              index < oldUser.pantryIds.count else {
            print("⚠️ Invalid pantry index")
            return
        }
        let pantryId = oldUser.pantryIds[index]
        currentPantryId = pantryId
        user = User(
            id: oldUser.id,
            displayName: oldUser.displayName,
            email: oldUser.email,
            profileImageName: oldUser.profileImageName,
            pantryIds: oldUser.pantryIds,
            currentPantryId: pantryId,
            createdAt: oldUser.createdAt,
            preferences: oldUser.preferences
        )
        print("✅ Current pantry updated:", pantryId)
    }

    // MARK: - 🔥 RESET (REQUIRED)
    func reset() {
        print("🔄 Resetting CurrentUser session")
        user = nil
        currentPantryId = nil
    }
}
