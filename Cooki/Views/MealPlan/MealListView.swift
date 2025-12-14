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
                .font(.headline)
            ForEach(meals) { meal in
                Text(meal.title)
            }
        }
    }
}

struct MealListView: View {
    let dailyMealPlan: MealPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(MealType.allCases, id: \.self) { type in
                if let recipes = dailyMealPlan.planData[type] {
                    MealTypeSectionView(type: type, meals: recipes)
                }
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView(dailyMealPlan: MockData.mealPlans[0])
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
