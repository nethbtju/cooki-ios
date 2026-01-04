//
//  SkeletonItemCard.swift
//  Cooki
//
//  Created by Rohit Valanki on 3/1/2026.
//


import SwiftUI

struct SkeletonItemCard: View {
    @State private var pulse = false

    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.25))
                .frame(height: CardLayout.gridCardWidth() * 0.45)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.25))
                .frame(height: 12)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 40, height: 10)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(10)
        .frame(
            width: CardLayout.gridCardWidth(),
            height: CardLayout.gridCardWidth() * CardLayout.AspectRatio.portrait.value
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.15))
        )
        .opacity(pulse ? 0.4 : 1.0)
        .animation(
            .easeInOut(duration: 1.1).repeatForever(autoreverses: true),
            value: pulse
        )
        .onAppear { pulse = true }
    }
}
