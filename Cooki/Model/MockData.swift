//
//  MockData.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

// MARK: - Mock Data Provider
/// Centralized location for all mock/preview data
enum MockData {
    
    // MARK: - Users
    static let user = User(
        displayName: "Neth",
        email: "neth@example.com",
        profileImageName: "ProfilePic",
        preferences: User.UserPreferences(
            dietaryPreferences: [.highProtein],
            servingsPerMeal: 2
        )
    )
    
    static let users: [User] = [
        User(
            displayName: "Neth",
            email: "neth@example.com",
            profileImageName: "ProfilePic",
            preferences: User.UserPreferences(
                dietaryPreferences: [.highProtein],
                servingsPerMeal: 2
            )
        ),
        User(
            displayName: "John",
            email: "john@example.com",
            preferences: User.UserPreferences(
                dietaryPreferences: [.vegetarian, .glutenFree]
            )
        ),
        User(
            displayName: "Jane",
            email: "jane@example.com",
            preferences: User.UserPreferences(
                dietaryPreferences: [.vegan],
                allergies: ["Nuts", "Soy"]
            )
        )
    ]
    
    // MARK: - Pantry Items
    static let pantryItems: [Item] = [
        Item(
            title: "Cottee's Strawberry Jam",
            quantity: .grams(375),
            expiryDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            location: .fridge,
            category: .condiments,
            imageName: "StrawberryJam"
        ),
        Item(
            title: "Full Cream Milk",
            quantity: .liters(1),
            expiryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            location: .fridge,
            category: .dairy,
            imageName: "Milk"
        ),
        Item(
            title: "Bananas",
            quantity: .pieces(7),
            expiryDate: Date(), // Expired today
            location: .pantry,
            category: .produce,
            imageName: "Bananas"
        ),
        Item(
            title: "Cottee's Strawberry Jam",
            quantity: .grams(375),
            expiryDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            location: .pantry,
            category: .condiments,
            imageName: "StrawberryJam"
        ),
        Item(
            title: "Full Cream Milk",
            quantity: .liters(1),
            expiryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            location: .freezer,
            category: .dairy,
            imageName: "Milk"
        )
    ]
    
    // MARK: - Recipes
    static let recipes: [Recipe] = [
        Recipe(
            title: "Rogan Josh Lamb",
            imageName: "FillerFoodImage",
            prepTime: 1800, // 30 minutes
            cookTime: 5400, // 90 minutes
            servings: 4,
            difficulty: .medium,
            dietaryPreferences: [.highProtein],
            mealTypes: [.dinner]
        ),
        Recipe(
            title: "Lemon Chicken",
            imageName: "FillerFoodImage2",
            prepTime: 900, // 15 minutes
            cookTime: 2100, // 35 minutes
            servings: 2,
            difficulty: .easy,
            dietaryPreferences: [.highProtein],
            mealTypes: [.lunch, .dinner]
        ),
        Recipe(
            title: "Beef Stir Fry",
            imageName: "FillerFoodImage3",
            prepTime: 1200, // 20 minutes
            cookTime: 600, // 10 minutes
            servings: 8,
            difficulty: .easy,
            mealTypes: [.dinner]
        ),
        Recipe(
            title: "Grilled Chicken Salad",
            imageName: "FillerFoodImage4",
            prepTime: 900, // 15 minutes
            cookTime: 1200, // 20 minutes
            servings: 3,
            difficulty: .easy,
            dietaryPreferences: [.highProtein, .lowCarb],
            mealTypes: [.lunch]
        ),
        Recipe(
            title: "Spaghetti Bolognese",
            imageName: "FillerFoodImage5",
            prepTime: 600, // 10 minutes
            cookTime: 1800, // 30 minutes
            servings: 5,
            difficulty: .medium,
            mealTypes: [.dinner]
        )
    ]
    
    // MARK: - Recipe Suggestions
    static let suggestions: [RecipeSuggestion] = [
        RecipeSuggestion(
            recipe: recipes[0],
            reason: .nutritionGoals,
            customMessage: "Meet your protein goals with this meal",
            confidence: 0.85,
            expiringItems: []
        ),
        RecipeSuggestion(
            recipe: recipes[1],
            reason: .quickMeal,
            customMessage: "Quick and easy meal option",
            confidence: 0.78,
            expiringItems: []
        ),
        RecipeSuggestion(
            recipe: recipes[2],
            reason: .expiringIngredients,
            customMessage: "Uses ingredients expiring soon",
            confidence: 0.92,
            expiringItems: [pantryItems[0], pantryItems[1]]
        ),
        RecipeSuggestion(
            recipe: recipes[3],
            reason: .dietaryPreference,
            customMessage: "Healthy low-carb option",
            confidence: 0.75,
            expiringItems: []
        ),
        RecipeSuggestion(
            recipe: recipes[4],
            reason: .popularRecipe,
            customMessage: "Family favorite meal",
            confidence: 0.88,
            expiringItems: []
        )
    ]
    
    // MARK: - Upload Items
    static let uploadItems: [Upload] = [
        Upload(
            fileName: "ReciptName1.png",
            fileSize: 2_456_789,
            status: .uploading,
            progress: 0.7
        ),
        Upload(
            fileName: "ReciptNameSuccessful.png",
            fileSize: 1_234_567,
            status: .success,
            uploadedDate: Date(),
            detectedItems: [pantryItems[0], pantryItems[1]]
        ),
        Upload(
            fileName: "FailedUploadFile.pdf",
            fileSize: 3_456_789,
            status: .failed,
            errorMessage: "Unable to process file. Please try again."
        )
    ]
    
    // MARK: - Meal Plans
    static let mealPlans: [MealPlan] = [
        
        // Today
        MealPlan(
            date: Date(),
            planData: [
                .breakfast: [
                    recipes[3] // Grilled Chicken Salad (placeholder breakfast)
                ],
                .lunch: [
                    recipes[1] // Lemon Chicken
                ],
                .dinner: [
                    recipes[0], // Rogan Josh Lamb
                    recipes[2]  // Beef Stir Fry
                ]
            ],
            completed: false
        ),
        
        // Tomorrow
        MealPlan(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            planData: [
                .lunch: [
                    recipes[4] // Spaghetti Bolognese
                ],
                .dinner: [
                    recipes[1] // Lemon Chicken
                ]
            ],
            completed: false
        ),
        
        // Yesterday (completed)
        MealPlan(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            planData: [
                .breakfast: [
                    recipes[3]
                ],
                .lunch: [
                    recipes[1]
                ],
                .dinner: [
                    recipes[0]
                ]
            ],
            completed: true
        )
    ]
    
    // MARK: - Daily Intake
    static let dailyIntakes: [DailyIntake] = [
        DailyIntake(
            date: Date(),
            totalIntake: IntakeProgress(
                units: .calories,
                userGoal: 1600,
                currentValue: 1200
            ),
            macros: [
                Macro(
                    macroType: .protein,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 60,
                        currentValue: 50
                    )
                ),
                Macro(
                    macroType: .carbohydrate,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 100,
                        currentValue: 40
                    )
                ),
                Macro(
                    macroType: .fat,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 100,
                        currentValue: 95
                    )
                )
            ]
        ),
        
        // Tomorrow (lighter day)
        DailyIntake(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            totalIntake: IntakeProgress(
                units: .calories,
                userGoal: 1600,
                currentValue: 800
            ),
            macros: [
                Macro(
                    macroType: .protein,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 60,
                        currentValue: 30
                    )
                ),
                Macro(
                    macroType: .carbohydrate,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 100,
                        currentValue: 50
                    )
                ),
                Macro(
                    macroType: .fat,
                    currentIntake: IntakeProgress(
                        units: .grams,
                        userGoal: 100,
                        currentValue: 40
                    )
                )
            ]
        )
    ]
}

// MARK: - Convenience Extensions for Preview Data
extension User {
    static var mock: User { MockData.user }
    static var mockUsers: [User] { MockData.users }
}

extension Item {
    static var mockItems: [Item] { MockData.pantryItems }
    static var mockItem: Item { MockData.pantryItems[0] }
}

extension Recipe {
    static var mockRecipes: [Recipe] { MockData.recipes }
    static var mockRecipe: Recipe { MockData.recipes[0] }
}

extension RecipeSuggestion {
    static var mockSuggestions: [RecipeSuggestion] { MockData.suggestions }
    static var mockSuggestion: RecipeSuggestion { MockData.suggestions[0] }
}

extension Upload {
    static var mockUploads: [Upload] { MockData.uploadItems }
    static var mockUpload: Upload { MockData.uploadItems[0] }
}

extension MealPlan {
    static var mockMealPlans: [MealPlan] { MockData.mealPlans }
    static var mockMealPlan: MealPlan { MockData.mealPlans[0] }
}

extension DailyIntake {
    static var mockDailyIntakes: [DailyIntake] { MockData.dailyIntakes }
    static var mockDailyIntake: DailyIntake { MockData.dailyIntakes[0] }
}
