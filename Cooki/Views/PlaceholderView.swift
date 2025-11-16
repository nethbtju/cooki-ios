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
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom) // keep safe area at bottom if needed
            
            Text(title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
    }
}
