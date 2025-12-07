//
//  CookiApp.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//  Modified by Neth Botheju on 23/11/2025.
//
import SwiftUI
import FirebaseCore

@main
struct CookiApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @State private var showLoading = true // <--- new state

    init() {
        // Configure Firebase on app launch
        FirebaseApp.configure()
        
        if AppConfig.enableDebugLogging {
            print("🔥 Firebase configured successfully")
            print("🔧 Environment: \(AppConfig.environment)")
            print("🔧 Skip Login: \(AppConfig.skipLoginInDevelopment)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLoading {
                    BasketLoadingView()
                        .transition(.opacity)
                } else {
                    RootCoordinatorView()
                        .environmentObject(appViewModel)
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Show loading for 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLoading = false
                    }
                }
            }
        }
    }
}
