//
//  SocialButton.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//
import SwiftUI

struct SocialButton: View {
    let bg: Color
    let systemIcon: String

    var body: some View {
        Button(action: { print("\(systemIcon) tapped") }) {
            Image(systemName: systemIcon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(bg)
                .clipShape(Circle())
        }
    }
}
