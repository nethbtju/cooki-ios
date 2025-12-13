//
//  MealPlanView.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct MealPlanView: View {

    // MARK: - Body
    var body: some View {
        
        VStack(alignment: .leading) {
            HorizontalDatePicker()
            ScrollView {
                Text("Daily Intake")
                HStack(spacing: 24){
                    DailyIntakeProgressBar(caloriesConsumed: 1200, caloriesTarget: 1600)
                    VStack {
                        MacroProgressBar(name: "Protein", current: 50, target: 60, color: Color(red: 0.95, green: 0.6, blue: 0.5), unit: "g")
                        MacroProgressBar(name: "Carbs", current: 40, target: 100, color: Color(red: 0.5, green: 0.6, blue: 0.95), unit: "g")
                        MacroProgressBar(name: "Fat", current: 95, target: 100, color: Color(red: 0.3, green: 0.8, blue: 0.75), unit: "g")
                    }
                }
                Text("Today's meal plan")
                VStack {
                    // Suggestion card
                    RecipeCard.suggestion(
                        recipeSuggestion: MockData.suggestions[1],
                        aiSuggestion: "Meet your protein goals with this meal",
                        action: { print("Add to meal plan") }
                    )
                    // Suggestion card
                    RecipeCard.suggestion(
                        recipeSuggestion: MockData.suggestions[1],
                        aiSuggestion: "Meet your protein goals with this meal",
                        action: { print("Add to meal plan") }
                    )
                    // Suggestion card
                    RecipeCard.suggestion(
                        recipeSuggestion: MockData.suggestions[1],
                        aiSuggestion: "Meet your protein goals with this meal",
                        action: { print("Add to meal plan") }
                    )
                    // Suggestion card
                    RecipeCard.suggestion(
                        recipeSuggestion: MockData.suggestions[1],
                        aiSuggestion: "Meet your protein goals with this meal",
                        action: { print("Add to meal plan") }
                    )
                }
            }
        }
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

