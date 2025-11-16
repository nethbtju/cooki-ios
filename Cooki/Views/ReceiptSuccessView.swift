//
//  ReceiptSuccessView.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

struct ReceiptSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar with back button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ReceiptContentCard(items: PantryItem.mockPantrytems)
        }
        .background {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .offset(x: -50, y: -50)
                .ignoresSafeArea()
        }
        .background(Color.secondaryPurple)
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
struct ReceiptSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReceiptSuccessView()
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
        }
    }
}
