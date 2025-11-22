//
//  SocialButton.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
import SwiftUI

/// Circular icon button for social login or quick actions
struct IconButton: View {
    let systemIcon: String
    let backgroundColor: Color
    let size: CGFloat
    let action: () -> Void
    
    init(
        systemIcon: String,
        backgroundColor: Color,
        size: CGFloat = 48,
        action: @escaping () -> Void
    ) {
        self.systemIcon = systemIcon
        self.backgroundColor = backgroundColor
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemIcon)
        }
        .buttonStyle(IconButtonStyle(backgroundColor: backgroundColor, size: size))
    }
}

// MARK: - Social Login Variants
extension IconButton {
    static func google(action: @escaping () -> Void) -> IconButton {
        IconButton(systemIcon: "envelope.fill", backgroundColor: .red, action: action)
    }
    
    static func apple(action: @escaping () -> Void) -> IconButton {
        IconButton(systemIcon: "apple.logo", backgroundColor: .black, action: action)
    }
    
    static func facebook(action: @escaping () -> Void) -> IconButton {
        IconButton(systemIcon: "f.circle.fill", backgroundColor: .blue, action: action)
    }
}

// MARK: - Preview
struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            IconButton.google(action: { print("Google tapped") })
            IconButton.apple(action: { print("Apple tapped") })
            IconButton.facebook(action: { print("Facebook tapped") })
        }
        .padding()
    }
}
