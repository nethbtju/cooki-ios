//
//  ReceiptSuccessView.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

struct ReceiptSuccessView: View {
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
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
    }
}

// MARK: - Preview
struct ReceiptSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptSuccessView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
