//
//  MainView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var selectedTab: Int = 0
    @State private var showAddItemSheet = false
    @State private var isLoggedOut = false
    @State private var navigationPath = NavigationPath()
    @State private var isPillsExpanded = false  // Add state for pills
    
    private var user: User {
        appViewModel.currentUser ?? User.mock
    }
    
    private var authService: FirebaseAuthService {
        FirebaseAuthService()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            if isLoggedOut {
                LoginView()
            } else {
                ZStack(alignment: .bottom) {
                    selectedView(selectedTab, user: user)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    let pillData: [(icon: String, text: String, action: () -> Void)] = [
                        ("scanner", "Scan receipt", { print("Scan tapped") }),
                        ("cube.box", "Add new item", { showAddItemSheet = true }),
                        ("magnifyingglass", "Add new recipe", { print("Recipe tapped") })
                    ]
                    
                    CustomTabBar(selectedTab: $selectedTab, isExpanded: $isPillsExpanded, pillData: pillData)
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
                    AddPantryItemView(onUploadReceipt: {
                        navigationPath.append("UploadReceipt")
                    })
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
                    .presentationBackground(.white)
                }
                .navigationDestination(for: String.self) { route in
                    if route == "UploadReceipt" {
                        UploadReceiptView(onNavigateToPantry: {
                            navigationPath.removeLast(navigationPath.count)
                            selectedTab = 1
                            isPillsExpanded = false  // Close pills when navigating back
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectedView(_ tab: Int, user: User) -> some View {
        switch tab {
        case 0:
            MainLayout(
                header: {
                    HomeHeader(user: user, authService: authService)
                        .onTapGesture {
                            logout()
                        }
                },
                content: {
                    HomeView(notificationText: "4 items in pantry expiring soon!")
                        .previewDevice("iPhone 15 Pro")
                        .preferredColorScheme(.light)
                }
            )
        case 1:
            MainLayout(header: { TabHeader(text: "Your Stock") }, content: { PantryView() })
        case 2:
            MainLayout(header: { TabHeader(text: "Calendar") },
                       content: { PlaceholderView(title: "Calendar") })
        case 3:
            MainLayout(header: { TabHeader(text: "Cart") },
                       content: { PlaceholderView(title: "Cart") })
        default:
            MainLayout(header: { HomeHeader(user: user, authService: authService) }, content: { HomeView() })
        }
    }
    
    // MARK: - Logout
    private func logout() {
        do {
            try authService.signOut()
            appViewModel.currentUser = nil
            isLoggedOut = true
            print("✅ User logged out")
        } catch {
            print("❌ Logout failed: \(error)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
            .environmentObject(AppViewModel())
    }
}
