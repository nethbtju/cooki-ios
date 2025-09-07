//
//  MainTabControllerView.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//

import SwiftUICore
import SwiftUI

struct MainTabControllerView: View {
    @State private var selectedTab: Tab = .pantry
    enum Tab { case pantry, userDetails, register }

    var body: some View {
        TabView(selection: $selectedTab) {
            PantryView().tabItem { Image(systemName: "cart.fill"); Text("Pantry") }.tag(Tab.pantry)
            UserDetailsView().tabItem { Image(systemName: "person.fill"); Text("Profile") }.tag(Tab.userDetails)
            RegisterView().tabItem { Image(systemName: "person.badge.plus.fill"); Text("Register") }.tag(Tab.register)
        }
        .accentColor(.accentBurntOrange)
    }
}
