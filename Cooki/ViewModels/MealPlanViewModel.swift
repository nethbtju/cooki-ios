//
//  MealPlanViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 14/12/2025.
//
import Foundation
import SwiftUI

@MainActor
class MealPlanViewModel: ObservableObject {
    
    @Published var mealPlans: [MealPlan]
    @Published var dailyIntakes: [DailyIntake]
    @Published var currentDayIndex: Int = 0
    
    init(
        mealPlans: [MealPlan] = MockData.mealPlans,
        dailyIntakes: [DailyIntake] = MockData.dailyIntakes
    ) {
        self.mealPlans = mealPlans
        self.dailyIntakes = dailyIntakes
    }
    
    // MARK: - Derived State
    
    var currentMealPlan: MealPlan? {
        mealPlans.indices.contains(currentDayIndex)
        ? mealPlans[currentDayIndex]
        : nil
    }
    
    var mealsGroupedByType: [MealType: [Recipe]] {
        currentMealPlan?.planData ?? [:]
    }
    
    var currentDailyIntake: DailyIntake? {
        dailyIntakes.indices.contains(currentDayIndex)
        ? dailyIntakes[currentDayIndex]
        : nil
    }
}
