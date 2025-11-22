//
//  MealPlan.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - Meal Plan Model
struct MealPlan: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var meals: [PlannedMeal]
    
    init(
        id: UUID = UUID(),
        date: Date,
        meals: [PlannedMeal] = []
    ) {
        self.id = id
        self.date = date
        self.meals = meals
    }
    
    // MARK: - Computed Properties
    var breakfast: PlannedMeal? {
        meals.first { $0.mealType == .breakfast }
    }
    
    var lunch: PlannedMeal? {
        meals.first { $0.mealType == .lunch }
    }
    
    var dinner: PlannedMeal? {
        meals.first { $0.mealType == .dinner }
    }
    
    var totalCalories: Int {
        meals.compactMap { $0.recipe.calories }.reduce(0, +)
    }
}

// MARK: - Planned Meal
struct PlannedMeal: Identifiable, Codable, Equatable {
    let id: UUID
    var recipe: Recipe
    var mealType: MealType
    var scheduledDate: Date
    var completed: Bool
    var notes: String?
    
    init(
        id: UUID = UUID(),
        recipe: Recipe,
        mealType: MealType,
        scheduledDate: Date,
        completed: Bool = false,
        notes: String? = nil
    ) {
        self.id = id
        self.recipe = recipe
        self.mealType = mealType
        self.scheduledDate = scheduledDate
        self.completed = completed
        self.notes = notes
    }
}
