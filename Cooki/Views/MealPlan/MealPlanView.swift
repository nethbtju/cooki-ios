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
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            
            VStack {
                HorizontalDatePicker()
                Spacer()
                HStack {
                    DailyIntakeDashboard(
                        caloriesConsumed: 1240,
                        caloriesTarget: 1600,
                        macros: [
                            MacroProgress(name: "Protein", current: 50, target: 60, color: Color(red: 0.95, green: 0.6, blue: 0.5), unit: "g"),
                            MacroProgress(name: "Carbs", current: 40, target: 100, color: Color(red: 0.5, green: 0.6, blue: 0.95), unit: "g"),
                            MacroProgress(name: "Fat", current: 95, target: 100, color: Color(red: 0.3, green: 0.8, blue: 0.75), unit: "g")
                        ]
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

