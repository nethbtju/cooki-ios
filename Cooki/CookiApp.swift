//
//  CookiApp.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//
import SwiftUI

@main
struct CookiApp: App {
    @State private var isLoggedIn = true
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}
