//
//  CheckoutFloatingButton.swift
//  Cooki
//
//  Created by Neth Botheju on 10/1/2026.
//
import SwiftUI

struct CheckoutFloatingButton: View {
    @Binding var isCheckedOut: Bool
    var action: () -> Void
    
    @State private var bounceScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                bounceScale = 1.15
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    bounceScale = 1.0
                }
            }
            
            action()
        }) {
            ZStack {
                Circle()
                    .fill(isCheckedOut ? Color.green : Color.accentBurntOrange)
                    .frame(width: 65, height: 65)
                    .shadow(color: Color.accentBurntOrange.opacity(0.4), radius: 12, x: 0, y: 4)
                
                if #available(iOS 17.0, *) {
                    Image(systemName: isCheckedOut ? "checkmark" : "receipt")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .contentTransition(.symbolEffect(.replace))
                        .animation(.smooth(duration: 0.5), value: isCheckedOut)
                } else {
                    Image(systemName: isCheckedOut ? "checkmark" : "receipt")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .animation(.smooth(duration: 0.5), value: isCheckedOut)
                }
            }
        }
        .scaleEffect(bounceScale)
    }
}

// MARK: - Preview
struct CheckoutFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutPreviewWrapper()
    }
}

struct CheckoutPreviewWrapper: View {
    @State private var isCheckedOut = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CheckoutFloatingButton(isCheckedOut: $isCheckedOut) {
                        isCheckedOut.toggle()
                        print("Checkout tapped - isCheckedOut: \(isCheckedOut)")
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
