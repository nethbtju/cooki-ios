//
//  MainLayout.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct MainLayout<Content: View>: View {
    let header: AnyView
    let content: Content
    
    init<Header: View>(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = AnyView(header())
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
