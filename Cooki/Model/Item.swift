//
//  FoodItem.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//  Updated to include pantryId for Firestore integration.
//

import Foundation

// MARK: - Storage Location
enum StorageLocation: String, Codable, CaseIterable {
    case fridge = "Fridge"
    case freezer = "Freezer"
    case pantry = "Pantry"
    case cupboard = "Cupboard"
    
    var icon: String {
        switch self {
        case .fridge: return "refrigerator"
        case .freezer: return "snowflake"
        case .pantry: return "cabinet"
        case .cupboard: return "archivebox"
        }
    }
}

// MARK: - Item Category
enum ItemCategory: String, Codable, CaseIterable {
    case produce = "Produce"
    case dairy = "Dairy"
    case meat = "Meat"
    case seafood = "Seafood"
    case grains = "Grains"
    case condiments = "Condiments"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case frozen = "Frozen"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .produce: return "leaf.fill"
        case .dairy: return "cup.and.saucer.fill"
        case .meat: return "flame.fill"
        case .seafood: return "fish.fill"
        case .grains: return "takeoutbag.and.cup.and.straw.fill"
        case .condiments: return "drop.fill"
        case .beverages: return "waterbottle.fill"
        case .snacks: return "birthday.cake.fill"
        case .frozen: return "snowflake"
        case .other: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - Expiry Status
enum ExpiryStatus: Codable {
    case expired
    case expiringSoon(days: Int)
    case fresh(days: Int)
    
    init(daysLeft: Int) {
        if daysLeft <= 0 {
            self = .expired
        } else if daysLeft < 4 {
            self = .expiringSoon(days: daysLeft)
        } else {
            self = .fresh(days: daysLeft)
        }
    }
    
    var daysLeft: Int {
        switch self {
        case .expired: return 0
        case .expiringSoon(let days): return days
        case .fresh(let days): return days
        }
    }
    
    var isExpired: Bool {
        if case .expired = self { return true }
        return false
    }
    
    var isExpiringSoon: Bool {
        if case .expiringSoon = self { return true }
        return false
    }
}

// MARK: - Item Model
struct Item: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var quantity: Quantity
    var expiryDate: Date?
    var addedDate: Date
    var location: StorageLocation
    var category: ItemCategory
    var imageName: String?
    var notes: String?
    var pantryId: UUID // <-- NEW: link to a pantry
    
    init(
        id: UUID = UUID(),
        title: String,
        quantity: Quantity,
        expiryDate: Date? = nil,
        addedDate: Date = Date(),
        location: StorageLocation = .pantry,
        category: ItemCategory = .other,
        imageName: String? = nil,
        notes: String? = nil,
        pantryId: UUID
    ) {
        self.id = id
        self.title = title
        self.quantity = quantity
        self.expiryDate = expiryDate
        self.addedDate = addedDate
        self.location = location
        self.category = category
        self.imageName = imageName
        self.notes = notes
        self.pantryId = pantryId
    }
    
    // MARK: - Computed Properties
    var expiryStatus: ExpiryStatus {
        guard let expiryDate = expiryDate else {
            return .fresh(days: 999) // No expiry date
        }
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day ?? 0
        return ExpiryStatus(daysLeft: daysLeft)
    }
    
    var daysUntilExpiry: Int {
        expiryStatus.daysLeft
    }
    
    var isExpired: Bool {
        expiryStatus.isExpired
    }
    
    var isExpiringSoon: Bool {
        expiryStatus.isExpiringSoon
    }
}

// MARK: - Quantity
extension Item {
    struct Quantity: Codable, Equatable {
        var value: Double
        var unit: Unit
        
        enum Unit: String, Codable, CaseIterable {
            case grams = "g"
            case kilograms = "kg"
            case milliliters = "mL"
            case liters = "L"
            case pieces = "pcs"
            case cups = "cups"
            case tablespoons = "tbsp"
            case teaspoons = "tsp"
            case ounces = "oz"
            case pounds = "lbs"
            
            var displayName: String {
                rawValue
            }
        }
        
        var displayString: String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 0
            let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
            return "\(valueString)\(unit.displayName)"
        }
        
        // Convenience initializers
        static func grams(_ value: Double) -> Quantity {
            Quantity(value: value, unit: .grams)
        }
        
        static func kilograms(_ value: Double) -> Quantity {
            Quantity(value: value, unit: .kilograms)
        }
        
        static func milliliters(_ value: Double) -> Quantity {
            Quantity(value: value, unit: .milliliters)
        }
        
        static func liters(_ value: Double) -> Quantity {
            Quantity(value: value, unit: .liters)
        }
        
        static func pieces(_ value: Double) -> Quantity {
            Quantity(value: value, unit: .pieces)
        }
    }
}

// MARK: - Hashable Conformance
extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
