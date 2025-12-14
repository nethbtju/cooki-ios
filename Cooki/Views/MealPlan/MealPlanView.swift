//
//  MealPlanView.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct MealPlanView: View {
    
    @StateObject private var viewModel = MealPlanViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HorizontalDatePicker(
                selectedDate: $viewModel.currentDayIndex
            )
            
            if let intake = viewModel.currentDailyIntake {
                DailyIntakeView(currentIntake: intake)
            }
            
            Text("Today's meal plan")
                .font(.headline)
            
            ScrollView {
                MealListView(
                    mealsGroupedByType: viewModel.mealsGroupedByType
                )
                .padding()
            }
        }
        .padding(.horizontal)
    }
}
struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

