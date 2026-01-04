//
//  FirebaseItemService.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/12/2025.
//

import Foundation
import FirebaseFirestore

class FirebaseItemService {
    private let db = Firestore.firestore()
    
    // MARK: - Fetch a single item
    func fetchItem(id: UUID) async throws -> Item {
        let docRef = db.collection("items").document(id.uuidString)
        
        let document = try await docRef.getDocument()
        
        guard document.exists, let data = document.data() else {
            throw NSError(
                domain: "FirebaseItemService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Item not found"]
            )
        }
        
        return try parseItem(from: data, id: id)
    }
    
    // MARK: - Fetch multiple items by UUIDs
    func fetchItems(byIds ids: [UUID]) async throws -> [Item] {
        guard !ids.isEmpty else { return [] }
        
        let batches = stride(from: 0, to: ids.count, by: 10).map {
            Array(ids[$0..<min($0 + 10, ids.count)])
        }
        
        var allItems: [Item] = []
        
        for batch in batches {
            let idStrings = batch.map { $0.uuidString }
            let snapshot = try await db.collection("items")
                .whereField(FieldPath.documentID(), in: idStrings)
                .getDocuments()
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any],
                   let id = UUID(uuidString: document.documentID) {
                    let item = try parseItem(from: data, id: id)
                    allItems.append(item)
                }
            }
        }
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebaseItemService: Fetched \(allItems.count) items")
        }
        
        return allItems
    }
    
    // MARK: - Helper: parse Item from Firestore data
    private func parseItem(from data: [String: Any], id: UUID) throws -> Item {
        guard let title = data["title"] as? String,
              let quantityDict = data["quantity"] as? [String: Any],
              let quantityValue = quantityDict["value"] as? Double,
              let quantityUnitRaw = quantityDict["unit"] as? String,
              let quantityUnit = Item.Quantity.Unit(rawValue: quantityUnitRaw),
              let addedTimestamp = data["addedDate"] as? Timestamp,
              let locationRaw = data["location"] as? String,
              let location = StorageLocation(rawValue: locationRaw),
              let categoryRaw = data["category"] as? String,
              let category = ItemCategory(rawValue: categoryRaw),
              let pantryIdString = data["pantryId"] as? String,
              let pantryId = UUID(uuidString: pantryIdString)
        else {
            throw NSError(
                domain: "FirebaseItemService",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Invalid item data format"]
            )
        }
        
        let expiryDate = (data["expiryDate"] as? Timestamp)?.dateValue()
        let imageName = data["imageName"] as? String
        let notes = data["notes"] as? String
        
        return Item(
            id: id,
            title: title,
            quantity: Item.Quantity(value: quantityValue, unit: quantityUnit),
            expiryDate: expiryDate,
            addedDate: addedTimestamp.dateValue(),
            location: location,
            category: category,
            imageName: imageName,
            notes: notes,
            pantryId: pantryId // <-- NEW
        )
    }
    
    // MARK: - Add or Update Item
    func saveItem(_ item: Item) async throws {
        let docRef = db.collection("items").document(item.id.uuidString)
        
        let data: [String: Any] = [
            "title": item.title,
            "quantity": ["value": item.quantity.value, "unit": item.quantity.unit.rawValue],
            "expiryDate": item.expiryDate.map { Timestamp(date: $0) } as Any,
            "addedDate": Timestamp(date: item.addedDate),
            "location": item.location.rawValue,
            "category": item.category.rawValue,
            "imageName": item.imageName as Any,
            "notes": item.notes as Any,
            "pantryId": item.pantryId.uuidString // <-- NEW
        ]
        
        try await docRef.setData(data)
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebaseItemService: Saved item \(item.title)")
        }
    }
    
    // MARK: - Delete Item
    func deleteItem(_ id: UUID) async throws {
        let docRef = db.collection("items").document(id.uuidString)
        try await docRef.delete()
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebaseItemService: Deleted item \(id)")
        }
    }
    
    // MARK: - Add Item to Current Pantry (helper)
    func addItemToCurrentPantry(_ item: Item, pantryService: FirebasePantryService) async throws {
        // Attach the current pantryId
        guard let pantryIdString = await CurrentUser.shared.currentPantryId,
              let pantryUUID = UUID(uuidString: pantryIdString) else {
            throw NSError(domain: "FirebaseItemService", code: 400, userInfo: [NSLocalizedDescriptionKey: "No current pantry selected"])
        }
        
        // Make a copy of the item with the pantryId
        var itemWithPantry = item
        itemWithPantry.pantryId = pantryUUID
        
        // Save the item first
        try await saveItem(itemWithPantry)
        
        // Add item ID to pantry
        try await pantryService.addItem(itemId: item.id, toPantryId: pantryUUID)
        
        if AppConfig.enableDebugLogging {
            print("✅ FirebaseItemService: Added item \(item.title) to pantry \(pantryUUID)")
        }
    }
}
