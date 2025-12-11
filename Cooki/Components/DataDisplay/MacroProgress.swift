//
//  MacroProgress.swift
//  Cooki
//
//  Created by Neth Botheju on 8/12/2025.
//
import SwiftUI

struct MacroProgress {
    let name: String
    let current: Double
    let target: Double
    let color: Color
    let unit: String
    
    var percentage: Double {
        min(current / target, 1.0)
    }
}

struct DailyIntakeDashboard: View {
    let caloriesConsumed: Double
    let caloriesTarget: Double
    
    let macros: [MacroProgress]
    
    var caloriesPercentage: Double {
        min(caloriesConsumed / caloriesTarget, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Daily intake")
                .font(AppFonts.heading4())
                .foregroundColor(.textGreyDark)
            
            HStack(spacing: 26) {
                // Circular calorie progress
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 7)
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .trim(from: 0, to: caloriesPercentage)
                        .stroke(Color.accentViolet,
                            style: StrokeStyle(lineWidth: 14, lineCap: .round)
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(Int(caloriesConsumed))")
                            .font(AppFonts.heading3())
                            .foregroundColor(.textGreyDark)
                        
                        Text("/ \(Int(caloriesTarget)) calories")
                            .font(.system(size: 16))
                            .foregroundColor(.textGrey)
                    }
                }
                
                // Macro progress bars
                VStack(spacing: 16) {
                    ForEach(macros, id: \.name) { macro in
                        MacroProgressBar(macro: macro)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct MacroProgressBar: View {
    let macro: MacroProgress
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(macro.name)
                .font(AppFonts.macroText())
                .foregroundColor(.primary)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(macro.color)
                        .frame(width: geometry.size.width * macro.percentage, height: 12)
                }
            }
            
            HStack {
                Spacer()
                Text("\(Int(macro.current))/\(Int(macro.target))\(macro.unit)")
                    .font(AppFonts.progressMacroText())
                    .foregroundColor(.textGrey3)
            }
        }
    }
}

struct DailyIntakePreview: View {
    var body: some View {
        ScrollView {
            VStack {
                DailyIntakeDashboard(
                    caloriesConsumed: 1240,
                    caloriesTarget: 1600,
                    macros: [
                        MacroProgress(name: "Protein", current: 50, target: 60, color: Color(red: 0.95, green: 0.6, blue: 0.5), unit: "g"),
                        MacroProgress(name: "Carbs", current: 40, target: 100, color: Color(red: 0.5, green: 0.6, blue: 0.95), unit: "g"),
                        MacroProgress(name: "Fat", current: 95, target: 100, color: Color(red: 0.3, green: 0.8, blue: 0.75), unit: "g")
                    ]
                )
                .padding()
            }
        }
        .background(Color.white)
    }
}

#Preview {
    DailyIntakePreview()
}
