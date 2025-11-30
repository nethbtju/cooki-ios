//
//  SelectionChip.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import SwiftUI

// MARK: - SelectionChip Component
struct SelectionChip: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
                Text(title)
                    .font(AppFonts.regularBody())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.accentBurntOrange : Color.backgroundGrey)
            .foregroundColor(isSelected ? .white : .textGrey)
            .cornerRadius(8)
        }
    }
}
