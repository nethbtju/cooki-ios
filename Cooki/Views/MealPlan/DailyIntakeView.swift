//
//  DailyIntakeView.swift
//  Cooki
//
//  Created by Neth Botheju on 14/12/2025.
//
import SwiftUI

struct DailyIntakeView: View {
    var currentIntake: DailyIntake
    
    var body: some View {
        HStack(spacing: 24) {
            DailyIntakeProgressBar(
                caloriesConsumed: currentIntake.totalIntake.currentValue,
                caloriesTarget: currentIntake.totalIntake.userGoal
            )
            
            VStack(spacing: 8) {
                ForEach(
                    currentIntake.macros,
                    id: \.macroType
                ) { macro in
                    MacroProgressBar(
                        name: macro.macroType.displayName,
                        current: macro.currentIntake.currentValue,
                        target: macro.currentIntake.userGoal,
                        color: macro.macroType.color,
                        unit: macro.currentIntake.units.rawValue
                    )
                }
            }
        }
    }
}

struct DailyIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeView(currentIntake: MockData.dailyIntakes[0])
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
