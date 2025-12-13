//
//  MacroProgressBar.swift
//  Cooki
//
//  Created by Neth Botheju on 13/12/2025.
//
import SwiftUI

struct MacroProgressBar: View {
    let name: String
    let current: Double
    let target: Double
    let color: Color
    let unit: String

    var percentage: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }

    var percentageText: String {
        "\(Int(percentage * 100))%"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // 🔤 Name (top left)
            Text(name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)

            // 📊 Progress Bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)

                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(
                            width: geometry.size.width * percentage,
                            height: 12
                        )
                }
            }
            .frame(height: 12)
            .clipped()

            // 📈 Percentage (bottom right)
            HStack {
                Spacer()
                Text("\(Int(current))/\(Int(target)) \(unit)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview
struct MacroProgress_Previews: PreviewProvider {
    static var previews: some View {
        MacroProgressBar(name: "Protein", current: 50, target: 60, color: Color(red: 0.95, green: 0.6, blue: 0.5), unit: "g")
    }
}
