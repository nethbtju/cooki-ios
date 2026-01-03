//
//  MacroProgress.swift
//  Cooki
//
//  Created by Neth Botheju on 8/12/2025.
//
import SwiftUI

struct DailyIntakeProgressBar: View {
    let caloriesConsumed: Double
    let caloriesTarget: Double
    
    var caloriesPercentage: Double {
        min(caloriesConsumed / caloriesTarget, 1.0)
    }
    
    var body: some View {
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
                        .foregroundColor(Color.textGrey3)
                    
                    Text("/ \(Int(caloriesTarget)) calories")
                        .font(.system(size: 16))
                        .foregroundColor(Color.textGrey)
                }
            }
        }
    }
}

// MARK: - Preview
struct DailyIntakeProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DailyIntakeProgressBar(
                caloriesConsumed: 1240,
                caloriesTarget: 1600,
            )
        }
    }
}
