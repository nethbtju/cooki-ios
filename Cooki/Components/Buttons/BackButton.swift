//
//  BackButton.swift
//  Cooki
//
//  Modified by Neth Botheju on 29/11/2025.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            if let action = action {
                // Use custom action if provided
                action()
            } else {
                // Otherwise use default dismiss
                dismiss()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                Text("Back")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Default dismiss behavior
            BackButton()
            
            // Custom action
            BackButton(action: {
                print("Custom back action")
            })
        }
        .padding()
        .background(Color.accentBurntOrange)
    }
}
