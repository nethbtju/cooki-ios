//
//  MainView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    @State private var showAddItemSheet = false

    var body: some View {
        let pillData: [(icon: String, text: String, action: () -> Void)] = [
            ("scanner", "Scan receipt", {
                print("Scan tapped")
            }),
            ("cube.box", "Add new item", {
                showAddItemSheet = true
            }),
            ("magnifyingglass", "Add new recipe", {
                print("Recipe tapped")
            })
        ]
        
        ZStack(alignment: .bottom) {
            selectedView(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
            CustomTabBar(selectedTab: $selectedTab, pillData: pillData)
                .ignoresSafeArea(.keyboard)
        }
        .overlay {
            if showAddItemSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.3), value: showAddItemSheet)
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddPantryItemView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
                .presentationBackground(.white)
        }
    }
}

@ViewBuilder
private func selectedView(_ tab: Int) -> some View {
    switch tab {
    case 0:
        MainLayout(header: { HomeHeader() }, content: {
            HomeView(notificationText: "4 items in pantry expiring soon!")
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
        })
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
