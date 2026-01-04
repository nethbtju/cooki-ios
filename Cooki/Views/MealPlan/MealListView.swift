//
//  MealListView.swift
//  Cooki
//
//  Created by Neth Botheju on 14/12/2025.
//
import SwiftUI

struct MealTypeSectionView: View {
    let type: MealType
    let meals: [Recipe]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.rawValue)
                .foregroundStyle(Color.textGrey)
            ForEach(meals) { meal in
                RecipeCard.mealPlan(
                    type: .plan,
                    plannedMeal: meal,
                    date: Date(),
                    action: { print("Add to meal plan") }
                )
            }
        }
    }
}

struct MealListView: View {
    let dailyMealPlan: [MealType: [Recipe]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(MealType.allCases, id: \.self) { type in
                if let recipes = dailyMealPlan[type] {
                    MealTypeSectionView(type: type, meals: recipes)
                }
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView(dailyMealPlan: MockData.mealPlans[0].planData)
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
