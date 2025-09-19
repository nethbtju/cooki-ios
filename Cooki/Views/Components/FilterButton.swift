//
//  FilterButton.swift
//  Cooki
//
//  Created by Rohit Valanki on 19/9/2025.
//


//
//  FilterButton.swift
//  Cooki
//
//  Created by Rohit Valanki on 17/9/2025.
//


//
//  FilterButton.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//


import SwiftUI

struct FilterButton: View {
    let title: String
    @Binding var isSelected: Bool
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            isSelected.toggle()
            action?()
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color.accentLightOrange) // text color
                .padding(.vertical, 5)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.accentLightOrange : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentLightOrange, lineWidth: 1)
                        )
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct FilterButton_Previews: PreviewProvider {
    @State static var selected = false

    static var previews: some View {
        HStack {
            FilterButton(title: "Vegetarian", isSelected: $selected)
            FilterButton(title: "Vegan", isSelected: .constant(true))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
