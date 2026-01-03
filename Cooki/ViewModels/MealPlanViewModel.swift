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
    
    @Published var mealPlans: [MealPlan] = []
    @Published var dailyIntakes: [DailyIntake] = []
    @Published var currentDate: Date
    @Published var isLoading = false
    
    private let calendar = Calendar.current
    private var loadedDates = Set<Date>() // Track which dates we've loaded
    
    // Dependencies (inject these for real data fetching)
    private let mealPlanService: MealPlanServiceProtocol
    private let dailyIntakeService: DailyIntakeServiceProtocol
    
    init(
        currentDate: Date = Date(),
        mealPlanService: MealPlanServiceProtocol = MealPlanService(),
        dailyIntakeService: DailyIntakeServiceProtocol = DailyIntakeService()
    ) {
        self.currentDate = calendar.startOfDay(for: currentDate)
        self.mealPlanService = mealPlanService
        self.dailyIntakeService = dailyIntakeService
        
        // Load initial data
        Task {
            await loadInitialData()
        }
    }
    
    // MARK: - Derived State
    
    var currentMealPlan: MealPlan? {
        mealPlans.first { plan in
            calendar.isDate(plan.date, inSameDayAs: currentDate)
        }
    }
    
    var mealsGroupedByType: [MealType: [Recipe]] {
        currentMealPlan?.planData ?? [:]
    }
    
    var currentDailyIntake: DailyIntake? {
        dailyIntakes.first { intake in
            calendar.isDate(intake.date, inSameDayAs: currentDate)
        }
    }
    
    var upcomingRecipes: [Recipe] {
        guard let planData = currentMealPlan?.planData else { return [] }
        
        // Flatten all recipes and take first 5
        return planData.values
            .flatMap { $0 }
            .prefix(5)
            .map { $0 }
    }
    
    // MARK: - Public Methods
    /// Call this when user selects a new date from the scrollable header
    func updateCurrentDate(_ newDate: Date) {
        let normalizedDate = calendar.startOfDay(for: newDate)
        guard normalizedDate != currentDate else { return }
        
        currentDate = normalizedDate
        
        // Lazy load data for this date if not already loaded
        Task {
            await loadDataIfNeeded(for: normalizedDate)
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // Load current day ± 2 days initially (user is likely to view these first)
        let datesToLoad = (-2...2).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: currentDate)
        }
        
        await loadData(for: datesToLoad)
    }
    
    private func loadDataIfNeeded(for date: Date) async {
        let normalizedDate = calendar.startOfDay(for: date)
        
        // Check if we've already loaded this date
        guard !loadedDates.contains(normalizedDate) else { return }
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // Load the selected date plus ±1 day buffer
        let datesToLoad = (-1...1).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: normalizedDate)
        }.filter { date in
            !loadedDates.contains(calendar.startOfDay(for: date))
        }
        
        guard !datesToLoad.isEmpty else { return }
        
        await loadData(for: datesToLoad)
    }
    
    private func loadData(for dates: [Date]) async {
        guard !dates.isEmpty else { return }
        
        do {
            // Fetch data for each date
            async let mealPlansTask = fetchMealPlansForDates(dates)
            async let intakesTask = fetchDailyIntakesForDates(dates)
            
            let (fetchedPlans, fetchedIntakes) = try await (mealPlansTask, intakesTask)
            
            // Merge new data with existing (avoid duplicates)
            let existingPlanDates = Set(mealPlans.map { calendar.startOfDay(for: $0.date) })
            let newPlans = fetchedPlans.filter { plan in
                !existingPlanDates.contains(calendar.startOfDay(for: plan.date))
            }
            mealPlans.append(contentsOf: newPlans)
            
            let existingIntakeDates = Set(dailyIntakes.map { calendar.startOfDay(for: $0.date) })
            let newIntakes = fetchedIntakes.filter { intake in
                !existingIntakeDates.contains(calendar.startOfDay(for: intake.date))
            }
            dailyIntakes.append(contentsOf: newIntakes)
            
            // Mark these dates as loaded
            dates.forEach { date in
                loadedDates.insert(calendar.startOfDay(for: date))
            }
            
        } catch {
            print("Error loading data for dates: \(error)")
        }
    }
    
    private func fetchMealPlansForDates(_ dates: [Date]) async throws -> [MealPlan] {
        guard let startDate = dates.min(), let endDate = dates.max() else {
            return []
        }
        return try await mealPlanService.fetchMealPlans(from: startDate, to: endDate)
    }
    
    private func fetchDailyIntakesForDates(_ dates: [Date]) async throws -> [DailyIntake] {
        guard let startDate = dates.min(), let endDate = dates.max() else {
            return []
        }
        return try await dailyIntakeService.fetchDailyIntakes(from: startDate, to: endDate)
    }
}

// TODO: REMOVE WHEN FIREBASE IS ATTACHED
// MARK: - Service Protocols
protocol MealPlanServiceProtocol {
    func fetchMealPlans(from startDate: Date, to endDate: Date) async throws -> [MealPlan]
}

protocol DailyIntakeServiceProtocol {
    func fetchDailyIntakes(from startDate: Date, to endDate: Date) async throws -> [DailyIntake]
}

// MARK: - Mock Implementation (for testing)
class MealPlanService: MealPlanServiceProtocol {
    func fetchMealPlans(from startDate: Date, to endDate: Date) async throws -> [MealPlan] {
        // TODO: Replace with actual API/database call
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        return MockData.mealPlans.filter { plan in
            plan.date >= startDate && plan.date <= endDate
        }
    }
}

class DailyIntakeService: DailyIntakeServiceProtocol {
    func fetchDailyIntakes(from startDate: Date, to endDate: Date) async throws -> [DailyIntake] {
        // TODO: Replace with actual API/database call
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        return MockData.dailyIntakes.filter { intake in
            intake.date >= startDate && intake.date <= endDate
        }
    }
}
