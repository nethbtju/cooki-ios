//
//  ButtonStyles.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
/*
CREATING CUSTOM CONFIGURATIONS:
================================

// Define a custom configuration
extension ButtonConfiguration {
    static let danger = ButtonConfiguration(
        backgroundColor: .red,
        foregroundColor: .white,
        font: AppFonts.buttonFont(),
        cornerRadius: 12
    )
}
 
 // Use it with PrimaryButton
 PrimaryButton(
     title: "Delete",
     action: { /* delete action */ },
     configuration: .danger
 )
 
*/
import SwiftUI

// MARK: - Button Configuration
/// Centralized configuration for button appearance
struct ButtonConfiguration {
    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font
    let cornerRadius: CGFloat
    let padding: EdgeInsets
    let borderColor: Color?
    let borderWidth: CGFloat
    
    init(
        backgroundColor: Color,
        foregroundColor: Color,
        font: Font,
        cornerRadius: CGFloat = 12,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    // MARK: - Preset Configurations
    static let primary = ButtonConfiguration(
        backgroundColor: .accentBurntOrange,
        foregroundColor: .white,
        font: AppFonts.buttonFont()
    )
    
    static let secondary = ButtonConfiguration(
        backgroundColor: .white,
        foregroundColor: .accentBurntOrange,
        font: AppFonts.buttonFont(),
        borderColor: .accentBurntOrange,
        borderWidth: 2
    )
    
    static let filter = ButtonConfiguration(
        backgroundColor: .white,
        foregroundColor: .accentLightOrange,
        font: .system(size: 14, weight: .medium),
        cornerRadius: 10,
        padding: EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16),
        borderColor: .accentLightOrange,
        borderWidth: 1
    )
    
    static let filterSelected = ButtonConfiguration(
        backgroundColor: .accentLightOrange,
        foregroundColor: .white,
        font: .system(size: 14, weight: .medium),
        cornerRadius: 10,
        padding: EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16),
        borderColor: .accentLightOrange,
        borderWidth: 1
    )
}

// MARK: - Base Button Style
/// Reusable button style that applies consistent styling based on configuration
struct ConfigurableButtonStyle: ButtonStyle {
    let configuration: ButtonConfiguration
    let isEnabled: Bool
    
    init(configuration: ButtonConfiguration, isEnabled: Bool = true) {
        self.configuration = configuration
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(self.configuration.font)
            .foregroundColor(self.configuration.foregroundColor)
            .padding(self.configuration.padding)
            .background(self.configuration.backgroundColor)
            .cornerRadius(self.configuration.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.configuration.cornerRadius)
                    .stroke(
                        self.configuration.borderColor ?? .clear,
                        lineWidth: self.configuration.borderWidth
                    )
            )
            .opacity(isEnabled ? (configuration.isPressed ? 0.7 : 1.0) : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style
/// Style for circular icon buttons (like social login buttons)
struct IconButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let size: CGFloat
    
    init(backgroundColor: Color, size: CGFloat = 48) {
        self.backgroundColor = backgroundColor
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
