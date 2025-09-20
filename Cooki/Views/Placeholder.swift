//
//  Placeholder.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
import SwiftUICore

struct PlaceholderView: View {
    let title: String
    var body: some View {
        ZStack {
            Color.secondaryPurple.ignoresSafeArea()
            Text(title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
    }
}
