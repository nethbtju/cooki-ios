//
//  CurrentUser.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/12/2025.
//

import SwiftUI

@MainActor
class CurrentUser: ObservableObject {

    @Published var user: User? {
        didSet {
            // Auto-select first pantry ONLY if none is selected
            if currentPantryId == nil, let firstPantry = user?.pantryIds.first {
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
        guard let user = user, user.pantryIds.contains(pantryId) else {
            print("⚠️ Pantry ID not found in user's pantries")
            return
        }
        currentPantryId = pantryId
        print("✅ Current pantry updated:", pantryId)
    }

    func setCurrentPantry(byIndex index: Int) {
        guard let user = user,
              index >= 0,
              index < user.pantryIds.count else {
            print("⚠️ Invalid pantry index")
            return
        }
        currentPantryId = user.pantryIds[index]
        print("✅ Current pantry updated:", currentPantryId!)
    }

    func reset() {
        print("🔄 Resetting CurrentUser session")
        user = nil
        currentPantryId = nil
    }
}
