//
//  CartButton.swift
//  Cooki
//
//  Created by Neth Botheju on 8/1/2026.
//
import SwiftUI

// MARK: - Added To Cart Button
struct AddedToCartButton: View {
    @Binding var addedToCart: Bool
    @Binding var bounceScale: CGFloat
    
    var body: some View {
        Button(action: handleCartTap) {
            ZStack {
                if addedToCart {
                    // Checkmark in green circle
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                } else {
                    // Cart icon in purple circle
                    Circle()
                        .fill(Color.accentDarkPurple.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.accentDarkPurple)
                }
            }
            .scaleEffect(bounceScale)
        }
    }
    
    private func handleCartTap() {
        if !addedToCart {
            // Single fluid animation - no delays needed
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                bounceScale = 0.8
                addedToCart = true
            }
            
            // Quick bounce back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.interpolatingSpring(stiffness: 400, damping: 15)) {
                    bounceScale = 1.15
                }
                
                // Settle to final size
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    withAnimation(.interpolatingSpring(stiffness: 350, damping: 18)) {
                        bounceScale = 1.0
                    }
                }
            }
        } else {
            // If already added, just toggle back
            addedToCart = false
            bounceScale = 1.0
        }
    }
}
