//
//  FilterButton.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
//
//  ToggleButton.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

/// Toggle button for filter or selection states
struct ToggleButton: View {
    let title: String
    @Binding var isSelected: Bool
    let onToggle: (() -> Void)?
    let selectedConfiguration: ButtonConfiguration
    let unselectedConfiguration: ButtonConfiguration
    
    init(
        title: String,
        isSelected: Binding<Bool>,
        onToggle: (() -> Void)? = nil,
        selectedConfiguration: ButtonConfiguration = .filterSelected,
        unselectedConfiguration: ButtonConfiguration = .filter
    ) {
        self.title = title
        self._isSelected = isSelected
        self.onToggle = onToggle
        self.selectedConfiguration = selectedConfiguration
        self.unselectedConfiguration = unselectedConfiguration
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            onToggle?()
        }) {
            Text(title).lineLimit(1)
        }
        .buttonStyle(
            ConfigurableButtonStyle(
                configuration: isSelected ? selectedConfiguration : unselectedConfiguration
            )
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Convenience Variants
extension ToggleButton {
    /// Filter button variant
    static func filter(
        title: String,
        isSelected: Binding<Bool>,
        onToggle: (() -> Void)? = nil
    ) -> ToggleButton {
        ToggleButton(
            title: title,
            isSelected: isSelected,
            onToggle: onToggle,
            selectedConfiguration: .filterSelected,
            unselectedConfiguration: .filter
        )
    }
}

// MARK: - Preview
struct ToggleButton_Previews: PreviewProvider {
    @State static var vegetarian = false
    @State static var vegan = true
    
    static var previews: some View {
        HStack(spacing: 12) {
            ToggleButton.filter(title: "Sort by location", isSelected: $vegetarian)
            ToggleButton.filter(title: "Filter", isSelected: $vegan)
        }
        .padding()
    }
}
