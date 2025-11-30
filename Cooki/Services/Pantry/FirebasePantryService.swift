//
//  FirebasePantryService.swift
//  Cooki
//
//  Created on 29/11/2025.
//

import Foundation
import FirebaseFirestore

class FirebasePantryService: PantryServiceProtocol {
    private let db = Firestore.firestore()
    
    // MARK: - Fetch Pantry
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
        
        // Firestore 'in' query limit is 10, so batch if needed
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
        let docRef = db.collection("pantries").document(pantry.id.uuidString)
        
        let data: [String: Any] = [
            "name": pantry.name,
            "items": pantry.items.map { $0.uuidString },
            "memberIds": pantry.memberIds,
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await docRef.updateData(data)
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Updated pantry - \(pantry.name)")
        }
    }
    
    // MARK: - Add Item
    func addItem(itemId: UUID, toPantryId: UUID) async throws {
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
        let docRef = db.collection("pantries").document(fromPantryId.uuidString)
        
        try await docRef.updateData([
            "memberIds": FieldValue.arrayRemove([userId]),
            "updatedAt": Timestamp(date: Date())
        ])
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebasePantryService: Removed member from pantry")
        }
    }
    
    // MARK: - Helper Methods
    private func parsePantry(from data: [String: Any], id: UUID) throws -> Pantry {
        guard let name = data["name"] as? String,
              let itemStrings = data["items"] as? [String],
              let memberIds = data["memberIds"] as? [String],
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
            createdAt: createdAtTimestamp.dateValue(),
            updatedAt: updatedAtTimestamp.dateValue()
        )
    }
}
