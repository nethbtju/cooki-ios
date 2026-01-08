//
//  MealPlanViewModel.swift
//  Cooki
//
//  Updated by Rohit Valanki on 06/01/2026.
//
import Foundation
import SwiftUI

@MainActor
class MealPlanViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published var mealPlans: [MealPlan] = []
    @Published var dailyIntakes: [DailyIntake] = []
    @Published var currentDate: Date
    @Published var isLoading = false
    
    // MARK: - Private State
    private let calendar = Calendar.current
    private var loadedDates = Set<Date>() // Track which dates we've loaded
    
    // MARK: - Dependencies
    private let mealPlanService: MealPlanServiceProtocol
    private let dailyIntakeService: DailyIntakeServiceProtocol
    
    // MARK: - Initializer
    init(
        currentDate: Date = Date(),
        mealPlanService: MealPlanServiceProtocol = MealPlanService(),
        dailyIntakeService: DailyIntakeServiceProtocol? = nil
    ) {
        self.currentDate = calendar.startOfDay(for: currentDate)
        self.mealPlanService = mealPlanService
        
        // Initialize main actor service safely
        if let dailyIntakeService = dailyIntakeService {
            self.dailyIntakeService = dailyIntakeService
        } else {
            self.dailyIntakeService = FirebaseDailyIntakeService()
        }
        
        // Load initial data
        Task { await loadInitialData() }
    }
    
    // MARK: - Derived State
    var currentDailyIntake: DailyIntake? {
        dailyIntakes.first { calendar.isDate($0.date, inSameDayAs: currentDate) }
    }
    
    var currentMealPlan: MealPlan? {
        mealPlans.first { calendar.isDate($0.date, inSameDayAs: currentDate) }
    }
    
    var mealsGroupedByType: [MealType: [Recipe]] {
        currentMealPlan?.planData ?? [:]
    }
    
    var upcomingRecipes: [Recipe] {
        guard let planData = currentMealPlan?.planData else { return [] }
        return planData.values.flatMap { $0 }.prefix(5).map { $0 }
    }
    
    // MARK: - Public Methods
    /// Call when user selects a new date
    func updateCurrentDate(_ newDate: Date) {
        let normalizedDate = calendar.startOfDay(for: newDate)
        guard normalizedDate != currentDate else { return }
        
        currentDate = normalizedDate
        
        Task {
            await loadDataIfNeeded(for: normalizedDate)
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Load current day ±2 days
        let datesToLoad = (-2...2).compactMap { calendar.date(byAdding: .day, value: $0, to: currentDate) }
        await loadData(for: datesToLoad)
    }
    
    private func loadDataIfNeeded(for date: Date) async {
        let normalizedDate = calendar.startOfDay(for: date)
        guard !loadedDates.contains(normalizedDate), !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // Load selected date ±1 day buffer
        let datesToLoad = (-1...1)
            .compactMap { calendar.date(byAdding: .day, value: $0, to: normalizedDate) }
            .filter { !loadedDates.contains(calendar.startOfDay(for: $0)) }
        
        await loadData(for: datesToLoad)
    }
    
    private func loadData(for dates: [Date]) async {
        guard !dates.isEmpty else { return }
        
        do {
            // Fetch meal plans and daily intakes concurrently
            async let mealPlansTask = fetchMealPlansForDates(dates)
            async let intakesTask = fetchDailyIntakesForDates(dates)
            
            let (fetchedPlans, fetchedIntakes) = try await (mealPlansTask, intakesTask)
            
            // Merge meal plans
            let existingPlanDates = Set(mealPlans.map { calendar.startOfDay(for: $0.date) })
            let newPlans = fetchedPlans.filter { !existingPlanDates.contains(calendar.startOfDay(for: $0.date)) }
            mealPlans.append(contentsOf: newPlans)
            
            // Merge daily intakes
            let existingIntakeDates = Set(dailyIntakes.map { calendar.startOfDay(for: $0.date) })
            let newIntakes = fetchedIntakes.filter { !existingIntakeDates.contains(calendar.startOfDay(for: $0.date)) }
            dailyIntakes.append(contentsOf: newIntakes)
            
            // Mark as loaded
            dates.forEach { loadedDates.insert(calendar.startOfDay(for: $0)) }
            
        } catch {
            print("Error loading data for dates: \(error)")
        }
    }
    
    // MARK: - Fetch Helpers
    private func fetchMealPlansForDates(_ dates: [Date]) async throws -> [MealPlan] {
        guard let startDate = dates.min(), let endDate = dates.max() else { return [] }
        return try await mealPlanService.fetchMealPlans(from: startDate, to: endDate)
    }
    
    private func fetchDailyIntakesForDates(_ dates: [Date]) async throws -> [DailyIntake] {
        guard let startDate = dates.min(), let endDate = dates.max() else { return [] }
        return try await dailyIntakeService.fetchDailyIntakes(from: startDate, to: endDate)
    }
}

// MARK: - Service Protocols
protocol MealPlanServiceProtocol {
    func fetchMealPlans(from startDate: Date, to endDate: Date) async throws -> [MealPlan]
}

protocol DailyIntakeServiceProtocol {
    func fetchDailyIntakes(from startDate: Date, to endDate: Date) async throws -> [DailyIntake]
}

// MARK: - Mock Implementations
class MealPlanService: MealPlanServiceProtocol {
    func fetchMealPlans(from startDate: Date, to endDate: Date) async throws -> [MealPlan] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return MockData.mealPlans.filter { $0.date >= startDate && $0.date <= endDate }
    }
}

class DailyIntakeService: DailyIntakeServiceProtocol {
    func fetchDailyIntakes(from startDate: Date, to endDate: Date) async throws -> [DailyIntake] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return MockData.dailyIntakes.filter { $0.date >= startDate && $0.date <= endDate }
    }
}
