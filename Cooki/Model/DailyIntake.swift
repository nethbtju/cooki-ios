//
//  DailyIntake.swift
//  Cooki
//
//  Created by Neth Botheju on 14/12/2025.
//
import Foundation
import SwiftUI

enum MacroType: String, Codable, CaseIterable {
    case carbohydrate
    case protein
    case fat
    
    var displayName: String {
        switch self {
        case .carbohydrate:
            return "Carbs"
        case .protein:
            return "Protein"
        case .fat:
            return "Fat"
        }
    }
    
    var color: Color {
        switch self {
        case .carbohydrate:
            return Color(red: 0.5, green: 0.6, blue: 0.95)  // Blue
        case .protein:
            return Color(red: 0.95, green: 0.6, blue: 0.5)   // Coral
        case .fat:
            return Color(red: 0.3, green: 0.8, blue: 0.75)   // Teal
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .carbohydrate: return 0
        case .protein: return 1
        case .fat: return 2
        }
    }
}

struct Macro: Codable, Equatable {
    let macroType: MacroType
    let currentIntake: IntakeProgress
}

struct IntakeProgress: Codable, Equatable {
    let units: MeasurementUnit
    let userGoal: Double
    let currentValue: Double
    
    func getProgressString() -> String {
        return "\(currentValue) / \(userGoal) \(units.rawValue)"
    }
    
    var getCurrentValuePercentage: Double {
        return Double(currentValue) / Double(userGoal) * 100
    }
}

// MARK: - Meal Plan Model
struct DailyIntake: Identifiable, Codable, Equatable {
    let id: String            // 🔹 CHANGED (was UUID)
    var date: Date
    var totalIntake: IntakeProgress
    var macros: [Macro]
    
    init(
        id: String = "",       // 🔹 CHANGED (was UUID())
        date: Date,
        totalIntake: IntakeProgress,
        macros: [Macro] = []
    ) {
        self.id = id
        self.date = date
        self.totalIntake = totalIntake
        self.macros = macros
    }
}
