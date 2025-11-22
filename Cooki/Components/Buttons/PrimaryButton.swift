//
//  CtaButton.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import SwiftUI

// Primary call-to-action button with full-width layout
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let configuration: ButtonConfiguration
    let isEnabled: Bool
    let fullWidth: Bool
    
    init(
        title: String,
        action: @escaping () -> Void,
        configuration: ButtonConfiguration = .primary,
        isEnabled: Bool = true,
        fullWidth: Bool = true
    ) {
        self.title = title
        self.action = action
        self.configuration = configuration
        self.isEnabled = isEnabled
        self.fullWidth = fullWidth
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: fullWidth ? .infinity : nil)
        }
        .buttonStyle(ConfigurableButtonStyle(configuration: configuration, isEnabled: isEnabled))
        .disabled(!isEnabled)
    }
}

// MARK: - Convenience Variants
extension PrimaryButton {
    /// Primary button with default orange styling
    static func primary(title: String, action: @escaping () -> Void, isEnabled: Bool = true) -> PrimaryButton {
        PrimaryButton(title: title, action: action, configuration: .primary, isEnabled: isEnabled)
    }
    
    /// Secondary button with outline styling
    static func secondary(title: String, action: @escaping () -> Void, isEnabled: Bool = true) -> PrimaryButton {
        PrimaryButton(title: title, action: action, configuration: .secondary, isEnabled: isEnabled)
    }
}

// MARK: - Preview
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            PrimaryButton.primary(title: "Continue", action: { print("Primary tapped") })
            PrimaryButton.secondary(title: "Cancel", action: { print("Secondary tapped") })
            PrimaryButton.primary(title: "Disabled", action: {}, isEnabled: false)
        }
        .padding()
    }
}
