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
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading, spacing: 16) {
                HorizontalDatePicker(
                    selectedDate: $viewModel.currentDate,
                    onDateChanged: { newDate in
                        viewModel.updateCurrentDate(newDate)
                    }
                )
                .padding(.horizontal)
                
                ScrollView {
                if let intake = viewModel.currentDailyIntake {
                    DailyIntakeView(currentIntake: intake)
                        .padding(.horizontal)
                }
                
                Text("Today's meal plan")
                    .font(.headline)
                    .foregroundStyle(Color.textGreyDark)
                    .padding(.horizontal)
                
                    MealListView(
                        dailyMealPlan: viewModel.currentMealPlan?.planData ?? [:]
                    )
                    .padding(.horizontal)
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

