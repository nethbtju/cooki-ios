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
        // Get the first pantry ID if available
        guard let firstPantryId = user.pantryIds.first else {
            if AppConfig.enableDebugLogging {
                print("⚠️ HomeViewModel: User has no pantries")
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
        guard !user.pantryIds.isEmpty else {
            if AppConfig.enableDebugLogging {
                print("⚠️ HomeViewModel: User has no pantries")
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let pantries = try await pantryService.fetchPantries(ids: user.pantryIds)
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
