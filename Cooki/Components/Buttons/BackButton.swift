//
//  BackButton.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
