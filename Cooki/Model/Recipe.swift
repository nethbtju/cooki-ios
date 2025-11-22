//
//  Recipe.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
////
//  Recipe.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - Dietary Preference
enum DietaryPreference: String, Codable, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten-Free"
    case dairyFree = "Dairy-Free"
    case keto = "Keto"
    case paleo = "Paleo"
    case lowCarb = "Low-Carb"
    case highProtein = "High-Protein"
    
    var icon: String {
        switch self {
        case .vegetarian: return "leaf.fill"
        case .vegan: return "leaf.circle.fill"
        case .glutenFree: return "g.circle.fill"
        case .dairyFree: return "drop.slash.fill"
        case .keto: return "k.circle.fill"
        case .paleo: return "p.circle.fill"
        case .lowCarb: return "chart.line.downtrend.xyaxis"
        case .highProtein: return "flame.fill"
        }
    }
}

// MARK: - Difficulty Level
enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var icon: String {
        switch self {
        case .easy: return "star.fill"
        case .medium: return "star.leadinghalf.filled"
        case .hard: return "star.slash.fill"
        }
    }
}

// MARK: - Meal Type
enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    case dessert = "Dessert"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        case .snack: return "apple.logo"
        case .dessert: return "birthday.cake.fill"
        }
    }
}

// MARK: - Recipe Base Protocol
protocol RecipeProtocol: Identifiable, Codable {
    var id: UUID { get }
    var title: String { get }
    var imageName: String { get }
    var prepTime: TimeInterval { get }
    var cookTime: TimeInterval { get }
    var servings: Int { get }
}

// MARK: - Recipe Model
struct Recipe: RecipeProtocol, Equatable, Hashable {
    let id: UUID
    var title: String
    var description: String?
    var imageName: String
    var prepTime: TimeInterval // in seconds
    var cookTime: TimeInterval // in seconds
    var servings: Int
    var difficulty: DifficultyLevel
    var ingredients: [Ingredient]
    var instructions: [String]
    var dietaryPreferences: [DietaryPreference]
    var mealTypes: [MealType]
    var tags: [String]
    var calories: Int?
    var protein: Double?
    var carbs: Double?
    var fat: Double?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        imageName: String = "default_item", // TODO: Add default item image
        prepTime: TimeInterval,
        cookTime: TimeInterval = 0,
        servings: Int,
        difficulty: DifficultyLevel = .medium,
        ingredients: [Ingredient] = [],
        instructions: [String] = [],
        dietaryPreferences: [DietaryPreference] = [],
        mealTypes: [MealType] = [.dinner],
        tags: [String] = [],
        calories: Int? = nil,
        protein: Double? = nil,
        carbs: Double? = nil,
        fat: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.instructions = instructions
        self.dietaryPreferences = dietaryPreferences
        self.mealTypes = mealTypes
        self.tags = tags
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
    
    // MARK: - Computed Properties
    var totalTime: TimeInterval {
        prepTime + cookTime
    }
    
    var formattedPrepTime: (hours: Int, minutes: Int) {
        let hours = Int(prepTime) / 3600
        let minutes = (Int(prepTime) % 3600) / 60
        return (hours, minutes)
    }
    
    var formattedCookTime: (hours: Int, minutes: Int) {
        let hours = Int(cookTime) / 3600
        let minutes = (Int(cookTime) % 3600) / 60
        return (hours, minutes)
    }
    
    var formattedTotalTime: (hours: Int, minutes: Int) {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        return (hours, minutes)
    }
    
    var isVegetarian: Bool {
        dietaryPreferences.contains(.vegetarian) || dietaryPreferences.contains(.vegan)
    }
    
    var isVegan: Bool {
        dietaryPreferences.contains(.vegan)
    }
}

// MARK: - Ingredient
extension Recipe {
    struct Ingredient: Identifiable, Codable, Equatable, Hashable {
        let id: UUID
        var name: String
        var quantity: Double
        var unit: String
        var notes: String?
        
        init(
            id: UUID = UUID(),
            name: String,
            quantity: Double,
            unit: String,
            notes: String? = nil
        ) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.unit = unit
            self.notes = notes
        }
        
        var displayString: String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            let quantityString = formatter.string(from: NSNumber(value: quantity)) ?? "\(quantity)"
            return "\(quantityString) \(unit) \(name)"
        }
    }
}
