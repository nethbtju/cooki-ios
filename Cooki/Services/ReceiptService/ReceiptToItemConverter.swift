//
//  ReceiptToItemConverter.swift
//  Cooki
//
//  Created by Rohit Valanki on 30/11/2025.
//

import Foundation

struct ReceiptToItemConverter {

    /// Converts ReceiptData into an array of Items
    static func convert(_ receipt: ReceiptData) async throws -> [Item] {

        // 🔐 Get current pantry ID from session
        guard
            let pantryIdString = await CurrentUser.shared.currentPantryId,
            let pantryId = UUID(uuidString: pantryIdString)
        else {
            throw NSError(
                domain: "ReceiptToItemConverter",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "No active pantry selected"]
            )
        }

        return receipt.items.map { receiptItem in
            Item(
                title: receiptItem.name,
                quantity: convertWeight(
                    receiptItem.weight,
                    qty: receiptItem.qty
                ),
                expiryDate: nil,            // User can set later
                location: .pantry,          // Default
                category: .other,           // Default
                pantryId: pantryId          // ✅ REQUIRED
            )
        }
    }

    /// Convert ReceiptWeight to Item.Quantity
    private static func convertWeight(
        _ weight: ReceiptWeight?,
        qty: Int
    ) -> Item.Quantity {

        guard let weight = weight else {
            return .pieces(Double(qty))
        }

        let totalValue = weight.value * Double(qty)

        switch weight.unit {
        case .g:
            return .grams(totalValue)
        case .kg:
            return .kilograms(totalValue)
        case .ml:
            return .milliliters(totalValue)
        case .l:
            return .liters(totalValue)
        case .pack, .packs:
            return .pieces(Double(qty))
        }
    }
}
