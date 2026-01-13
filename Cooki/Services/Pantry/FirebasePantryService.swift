//
//  FirebasePantryService.swift
//  Cooki
//
//  Updated by Rohit Valanki
//

import Foundation
import FirebaseFirestore

class FirebasePantryService: PantryServiceProtocol {
    private let db = Firestore.firestore()
    
    // MARK: - Fetch Single Pantry
    func fetchPantry(id: UUID) async throws -> Pantry {
        let docRef = db.collection("pantries").document(id.uuidString)
        
        do {
            let document = try await docRef.getDocument()
            
            guard document.exists else {
                throw NSError(
                    domain: "PantryService",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Pantry not found"]
                )
            }
            
            guard let data = document.data() else {
                throw NSError(
                    domain: "PantryService",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to decode pantry data"]
                )
            }
            
            return try parsePantry(from: data, id: id)
        } catch {
            if AppConfig.enableDebugLogging {
                print("❌ FirebasePantryService: Failed to fetch pantry - \(error.localizedDescription)")
            }
            throw error
        }
    }
    
    // MARK: - Fetch Multiple Pantries
    func fetchPantries(ids: [UUID]) async throws -> [Pantry] {
        guard !ids.isEmpty else { return [] }
        
        let batches = stride(from: 0, to: ids.count, by: 10).map {
            Array(ids[$0..<min($0 + 10, ids.count)])
        }
        
        var allPantries: [Pantry] = []
        
        for batch in batches {
            let idStrings = batch.map { $0.uuidString }
            let snapshot = try await db.collection("pantries")
                .whereField(FieldPath.documentID(), in: idStrings)
                .getDocuments()
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any],
                   let id = UUID(uuidString: document.documentID) {
                    let pantry = try parsePantry(from: data, id: id)
                    allPantries.append(pantry)
                }
            }
        }
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Fetched \(allPantries.count) pantries")
        }
        
        return allPantries
    }
    
    // MARK: - Create Pantry
    func createPantry(name: String, memberIds: [String]) async throws -> Pantry {
        let pantry = Pantry(
            name: name,
            memberIds: memberIds
        )
        
        let docRef = db.collection("pantries").document(pantry.id.uuidString)
        
        let data: [String: Any] = [
            "name": pantry.name,
            "items": pantry.items.map { $0.uuidString },
            "memberIds": pantry.memberIds,
            "joinToken": pantry.joinToken, // ✅ include joinToken
            "joinRequests": [],
            "createdAt": Timestamp(date: pantry.createdAt),
            "updatedAt": Timestamp(date: pantry.updatedAt)
        ]
        
        try await docRef.setData(data)
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Created pantry - \(pantry.name)")
        }
        
        return pantry
    }
    
    // MARK: - Update Pantry
    func updatePantry(_ pantry: Pantry) async throws {
        try await authorizeUser(forPantryId: pantry.id)
        
        let docRef = db.collection("pantries").document(pantry.id.uuidString)
        
        let data: [String: Any] = [
            "name": pantry.name,
            "items": pantry.items.map { $0.uuidString },
            "memberIds": pantry.memberIds,
            "joinToken": pantry.joinToken, // ✅ include joinToken
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await docRef.updateData(data)
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Updated pantry - \(pantry.name)")
        }
    }
    
    // MARK: - Add Item
    func addItem(itemId: UUID, toPantryId: UUID) async throws {
        try await authorizeUser(forPantryId: toPantryId)
        
        let docRef = db.collection("pantries").document(toPantryId.uuidString)
        try await docRef.updateData([
            "items": FieldValue.arrayUnion([itemId.uuidString]),
            "updatedAt": Timestamp(date: Date())
        ])
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Added item to pantry")
        }
    }
    
    // MARK: - Remove Item
    func removeItem(itemId: UUID, fromPantryId: UUID) async throws {
        try await authorizeUser(forPantryId: fromPantryId)
        
        let docRef = db.collection("pantries").document(fromPantryId.uuidString)
        try await docRef.updateData([
            "items": FieldValue.arrayRemove([itemId.uuidString]),
            "updatedAt": Timestamp(date: Date())
        ])
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Removed item from pantry")
        }
    }
    
    // MARK: - Add Member
    func addMember(userId: String, toPantryId: UUID) async throws {
        try await authorizeUser(forPantryId: toPantryId)
        
        let pantry = try await fetchPantry(id: toPantryId)
        
        // Prevent duplicate members
        guard !pantry.memberIds.contains(userId) else {
            if AppConfig.enableDebugLogging {
                print("⚠️ User \(userId) is already a member of pantry \(toPantryId)")
            }
            return
        }
        
        let docRef = db.collection("pantries").document(toPantryId.uuidString)
        try await docRef.updateData([
            "memberIds": FieldValue.arrayUnion([userId]),
            "updatedAt": Timestamp(date: Date())
        ])
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Added member to pantry")
        }
    }
    
    // MARK: - Remove Member
    func removeMember(userId: String, fromPantryId: UUID) async throws {
        try await authorizeUser(forPantryId: fromPantryId)
        
        let docRef = db.collection("pantries").document(fromPantryId.uuidString)
        try await docRef.updateData([
            "memberIds": FieldValue.arrayRemove([userId]),
            "updatedAt": Timestamp(date: Date())
        ])
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Removed member from pantry")
        }
    }
    
    // MARK: - Fetch Current User Pantry (with authorization check)
    func fetchCurrentUserPantry() async throws -> Pantry {
        guard let currentUser = await CurrentUser.shared.user else {
            throw NSError(domain: "PantryService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        guard let pantryId = await CurrentUser.shared.currentPantryId,
              let pantryUUID = UUID(uuidString: pantryId) else {
            throw NSError(domain: "PantryService", code: 400, userInfo: [NSLocalizedDescriptionKey: "No current pantry selected"])
        }

        let pantry = try await fetchPantry(id: pantryUUID)

        guard pantry.memberIds.contains(currentUser.id) else {
            throw NSError(domain: "PantryService", code: 403, userInfo: [NSLocalizedDescriptionKey: "User is not authorized for this pantry"])
        }

        return pantry
    }
    
    // MARK: - Helper: Parse Pantry from Firestore Data
    private func parsePantry(from data: [String: Any], id: UUID) throws -> Pantry {
        guard let name = data["name"] as? String,
              let itemStrings = data["items"] as? [String],
              let memberIds = data["memberIds"] as? [String],
              let joinToken = data["joinToken"] as? String, // ✅ parse joinToken
              let createdAtTimestamp = data["createdAt"] as? Timestamp,
              let updatedAtTimestamp = data["updatedAt"] as? Timestamp else {
            throw NSError(
                domain: "PantryService",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Invalid pantry data format"]
            )
        }
        
        let items = itemStrings.compactMap { UUID(uuidString: $0) }
        
        return Pantry(
            id: id,
            name: name,
            items: items,
            memberIds: memberIds,
            joinToken: joinToken, // ✅ assign joinToken
            createdAt: createdAtTimestamp.dateValue(),
            updatedAt: updatedAtTimestamp.dateValue()
        )
    }
    
    // MARK: - Helper: Authorization Check
    private func authorizeUser(forPantryId pantryId: UUID) async throws {
        guard let currentUser = await CurrentUser.shared.user else {
            throw NSError(domain: "PantryService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        let pantry = try await fetchPantry(id: pantryId)
        
        guard pantry.memberIds.contains(currentUser.id) else {
            throw NSError(domain: "PantryService", code: 403, userInfo: [NSLocalizedDescriptionKey: "User is not authorized for this pantry"])
        }
    }
    
    // MARK: - Helper: Check if a user is already a member
    func isUserMember(userId: String, pantryId: UUID) async throws -> Bool {
        let pantry = try await fetchPantry(id: pantryId)
        return pantry.memberIds.contains(userId)
    }
}
