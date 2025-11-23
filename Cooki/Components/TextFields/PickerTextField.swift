//
//  PickerTextField.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import SwiftUI

// MARK: - PickerTextField
struct PickerTextField: View {
    let placeholder: String
    let selectedValue: String
    let isFocused: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .font(AppFonts.lightBody())
                    .foregroundColor(selectedValue.isEmpty ? .textGrey.opacity(0.6) : .textGrey)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(.textGrey)
                    .rotationEffect(.degrees(isFocused ? 180 : 0))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.textGrey)
            )
        }
    }
}
