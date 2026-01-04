//
//  SkeletonGrid.swift
//  Cooki
//
//  Created by Rohit Valanki on 3/1/2026.
//


import SwiftUI

struct SkeletonGrid: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<9, id: \.self) { _ in
                SkeletonItemCard()
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 130)
    }
}
