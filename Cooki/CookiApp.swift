//
//  CookiApp.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import SwiftUI

@main
struct CookiApp: App {
    @StateObject private var appViewModel = AppViewModel()
    
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
