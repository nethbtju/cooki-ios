//
//  ReceiptData.swift
//  Cooki
//
//  Created by Rohit Valanki on 30/11/2025.
//


//
//  ReceiptData.swift
//  Cooki
//
//  Created on 30/11/2025.
//

import Foundation

// MARK: - Receipt Data Models

struct ReceiptData: Codable {
    let storeName: String
    let date: String?
    let totalAmount: Double?
    let items: [ReceiptItem]
    
    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case date
        case totalAmount = "total_amount"
        case items
    }
}

struct ReceiptItem: Codable, Identifiable {
    let id: UUID
    let name: String
    let qty: Int
    let weight: ReceiptWeight?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case qty
        case weight
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.weight = try container.decodeIfPresent(ReceiptWeight.self, forKey: .weight)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
    }
    
    init(name: String, qty: Int, weight: ReceiptWeight?, price: Double?) {
        self.id = UUID()
        self.name = name
        self.qty = qty
        self.weight = weight
        self.price = price
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(qty, forKey: .qty)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encodeIfPresent(price, forKey: .price)
    }
}

struct ReceiptWeight: Codable {
    let value: Double
    let unit: WeightUnit
    
    enum WeightUnit: String, Codable {
        case g = "g"
        case kg = "kg"
        case ml = "ml"
        case l = "l"
        case pack = "pack"
        case packs = "packs"
    }
}

// MARK: - Example/Mock Data
extension ReceiptData {
    static var example: ReceiptData {
        ReceiptData(
            storeName: "Coles Supermarkets Australia Pty Ltd",
            date: "08/09/2025",
            totalAmount: 24.58,
            items: [
                ReceiptItem(
                    name: "SCHWEPPES SOLO LEMON 600ML",
                    qty: 1,
                    weight: ReceiptWeight(value: 600, unit: .ml),
                    price: 4.00
                ),
                ReceiptItem(
                    name: "ORGANIC KENT PUMPKIN PERKG",
                    qty: 1,
                    weight: nil,
                    price: 4.58
                ),
                ReceiptItem(
                    name: "0.776 kg NET @ $5.90/kg COLES BEEF CHUCK 850GRAM",
                    qty: 1,
                    weight: ReceiptWeight(value: 0.776, unit: .kg),
                    price: 16.00
                )
            ]
        )
    }
}