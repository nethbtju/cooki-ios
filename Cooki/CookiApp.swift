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
    
    init() {
        // Configure Firebase on app launch
        FirebaseApp.configure()
        
        if AppConfig.enableDebugLogging {
            print("🔥 Firebase configured successfully")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                MainView()
                    .environmentObject(appViewModel)
            } else if appViewModel.isAuthenticated {
                MainView()
                    .environmentObject(appViewModel)
            } else {
                LoginView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
