//
//  HomeViewModel.swift
//  Cooki
//
//  Created on 29/11/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pantry: Pantry?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Services
    private let pantryService: PantryServiceProtocol
    
    // MARK: - Init
    init(pantryService: PantryServiceProtocol = ServiceFactory.shared.makePantryService()) {
        self.pantryService = pantryService
    }
    
    // MARK: - Fetch Pantry
    func fetchPantry(for user: User) async {
        // Convert first pantry ID to UUID
        guard let firstPantryIdString = user.pantryIds.first,
              let firstPantryId = UUID(uuidString: firstPantryIdString) else {
            if AppConfig.enableDebugLogging {
                print("⚠️ HomeViewModel: User has no valid pantries")
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPantry = try await pantryService.fetchPantry(id: firstPantryId)
            self.pantry = fetchedPantry
            
            if AppConfig.enableDebugLogging {
                print("✅ HomeViewModel: Fetched pantry - \(fetchedPantry.name)")
                print("   Items: \(fetchedPantry.items.count)")
                print("   Members: \(fetchedPantry.memberIds.count)")
            }
        } catch {
            errorMessage = error.localizedDescription
            if AppConfig.enableDebugLogging {
                print("❌ HomeViewModel: Failed to fetch pantry - \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch All Pantries
    func fetchAllPantries(for user: User) async {
        // Convert pantry IDs to UUID
        let pantryUUIDs = user.pantryIds.compactMap { UUID(uuidString: $0) }
        
        guard !pantryUUIDs.isEmpty else {
            if AppConfig.enableDebugLogging {
                print("⚠️ HomeViewModel: User has no valid pantries")
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let pantries = try await pantryService.fetchPantries(ids: pantryUUIDs)
            // For now, just use the first one
            self.pantry = pantries.first
            
            if AppConfig.enableDebugLogging {
                print("✅ HomeViewModel: Fetched \(pantries.count) pantries")
            }
        } catch {
            errorMessage = error.localizedDescription
            if AppConfig.enableDebugLogging {
                print("❌ HomeViewModel: Failed to fetch pantries - \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }
}
