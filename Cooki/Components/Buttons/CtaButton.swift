//
//  CtaButton.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

struct CtaButton: View {
    let ctaText: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(ctaText)
                .font(AppFonts.buttonFont())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentBurntOrange)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 24)
    }
}
