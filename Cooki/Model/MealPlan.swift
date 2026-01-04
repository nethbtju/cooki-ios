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
    var planData: [MealType : [Recipe]]
    var completed: Bool
    
    init(
        id: UUID = UUID(),
        date: Date,
        planData: [MealType : [Recipe]] = [:],
        completed: Bool = false,
    ) {
        self.id = id
        self.date = date
        self.planData = planData
        self.completed = completed
    }
}
