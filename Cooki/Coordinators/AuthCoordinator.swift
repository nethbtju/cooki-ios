//
//  AuthCoordinator.swift
//  Cooki
//
//  Created by Neth Botheju on 29/11/2025.
//

import SwiftUI

/// Routes available in the auth navigation stack
enum AuthRoute: Hashable {
    case login
    case register
    case userDetails
}

/// Coordinator for managing authentication navigation
@MainActor
class AuthCoordinator: ObservableObject {
    /// Single navigation path for all auth screens
    @Published var path = NavigationPath()
    
    // MARK: - Navigation Methods
    
    /// Push a route onto the navigation stack
    func push(_ route: AuthRoute) {
        path.append(route)
        print("🧭 AuthCoordinator - Pushed \(route), path count: \(path.count)")
    }
    
    /// Push UserDetailsView when profile completion is needed
    func pushUserDetails() {
        path.append(AuthRoute.userDetails)
        print("🧭 AuthCoordinator - Pushed userDetails, path count: \(path.count)")
    }
    
    /// Pop from the navigation stack
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
        print("🧭 AuthCoordinator - Popped, path count: \(path.count)")
    }
    
    /// Pop to root (LoginView)
    func popToRoot() {
        path = NavigationPath()
        print("🧭 AuthCoordinator - Popped to root")
    }
    
    /// Reset the coordinator (clears navigation)
    func reset() {
        path = NavigationPath()
        print("🧭 AuthCoordinator - Reset navigation")
    }
}
