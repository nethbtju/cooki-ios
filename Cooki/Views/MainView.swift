//
//  MainView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
import SwiftUICore

struct MainView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: PlaceholderView(title: "List")
                case 2: PlaceholderView(title: "Calendar")
                case 3: PlaceholderView(title: "Cart")
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 80)
                .padding(.bottom, 75)
        }
    }
}
