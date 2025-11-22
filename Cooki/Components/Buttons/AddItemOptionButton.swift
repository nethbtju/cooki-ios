//
//  AddItemOptionButton.swift
//  Cooki
//
//  Created by Neth Botheju on 6/10/2025.
//
import SwiftUI

struct AddItemOptionButton: View {
    var iconName: String
    var title: String
    var subtitle: String
    var primaryColor: Color
    var secondaryColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer background (peach)
                RoundedRectangle(cornerRadius: 28)
                    .fill(secondaryColor.opacity(0.3))
                
                // Inner card (white with orange border)
                RoundedRectangle(cornerRadius: 22)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(primaryColor, lineWidth: 3)
                    )
                    .padding(6)
                
                // Content
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(secondaryColor.opacity(0.1)) // soft peach circle
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: iconName)
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

struct AddItemOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) { // consistent spacing between buttons
            AddItemOptionButton(
                iconName: "camera.fill",
                title: "Use Camera",
                subtitle: "Take a photo of your receipt",
                primaryColor: Color.accentBurntOrange,
                secondaryColor: Color.accentPeach
            ) {
                print("Camera tapped!")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
    }
}
