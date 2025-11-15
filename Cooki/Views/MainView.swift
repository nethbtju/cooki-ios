//
//  MainView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            selectedView(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(selectedTab: $selectedTab)
                .ignoresSafeArea(.keyboard)
        }
    }
}

@ViewBuilder
private func selectedView(_ tab: Int) -> some View {
    switch tab {
    case 0:
        MainLayout(header: { HomeHeader() }, content: { HomeView() })
    case 1:
        MainLayout(header: { Header(text: "Your Stock") }, content: { PantryView() })
    case 2:
        MainLayout(header: { Header(text: "Calendar") },
                   content: { PlaceholderView(title: "Calendar") })
    case 3:
        MainLayout(header: { Header(text: "Cart") },
                   content: { PlaceholderView(title: "Cart") })
    default:
        MainLayout(header: { HomeHeader() }, content: { HomeView() })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
