//
//  AddItemOptionButton.swift
//  Cooki
//
//  Created by Neth Botheju on 6/10/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import SwiftUI

/// Large card-style button with icon, title, and subtitle
struct OptionCardButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let primaryColor: Color
    let secondaryColor: Color
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        primaryColor: Color = .accentBurntOrange,
        secondaryColor: Color = .accentPeach,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer background
                RoundedRectangle(cornerRadius: 28)
                    .fill(secondaryColor.opacity(0.3))
                
                // Inner card with border
                RoundedRectangle(cornerRadius: 22)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(primaryColor, lineWidth: 3)
                    )
                    .padding(6)
                
                // Content
                VStack(spacing: 10) {
                    // Icon container
                    ZStack {
                        Circle()
                            .fill(secondaryColor.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: icon)
                            .font(.system(size: 38, weight: .regular))
                            .foregroundColor(primaryColor)
                    }
                    .padding(.bottom, 4)
                    
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(primaryColor)
                    
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 220)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct OptionCardButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            OptionCardButton(
                icon: "camera.fill",
                title: "Use Camera",
                subtitle: "Take a photo of your receipt",
                action: { print("Camera tapped") }
            )
            
            OptionCardButton(
                icon: "photo.fill",
                title: "Choose Photo",
                subtitle: "Select from your gallery",
                action: { print("Photo tapped") }
            )
        }
        .padding()
    }
}
