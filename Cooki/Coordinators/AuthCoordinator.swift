//
//  AuthCoordinator.swift
//  Cooki
//
//  Created by Neth Botheju on 29/11/2025.
//

import SwiftUI

/// Routes available in the registration flow
enum RegistrationRoute: Hashable {
    case register
    case userDetails
}

/// Coordinator for managing authentication navigation
@MainActor
class AuthCoordinator: ObservableObject {
    /// Current authentication flow state
    @Published var currentFlow: AuthFlow = .login
    
    /// Navigation path for the registration stack
    @Published var registrationPath: NavigationPath = NavigationPath()
    
    /// Available authentication flows
    enum AuthFlow {
        case login          // Login screen (no navigation stack)
        case registration   // Registration flow (register → user details)
    }
    
    // MARK: - Flow Navigation
    
    /// Start the registration flow (creates a new stack)
    func startRegistrationFlow() {
        currentFlow = .registration
        registrationPath = NavigationPath()
        
        if AppConfig.enableDebugLogging {
            print("🧭 AuthCoordinator: Started registration flow")
        }
    }
    
    /// Return to login flow (discards registration stack)
    func returnToLogin() {
        currentFlow = .login
        registrationPath = NavigationPath()
        
        if AppConfig.enableDebugLogging {
            print("🧭 AuthCoordinator: Returned to login flow")
        }
    }
    
    // MARK: - Registration Stack Navigation
    
    /// Push a route onto the registration stack
    func push(_ route: RegistrationRoute) {
        registrationPath.append(route)
        
        if AppConfig.enableDebugLogging {
            print("🧭 AuthCoordinator: Pushed \(route)")
            print("   Registration path count: \(registrationPath.count)")
        }
    }
    
    /// Pop from the registration stack
    func pop() {
        guard !registrationPath.isEmpty else { return }
        registrationPath.removeLast()
        
        if AppConfig.enableDebugLogging {
            print("🧭 AuthCoordinator: Popped from registration stack")
            print("   Registration path count: \(registrationPath.count)")
        }
    }
    
    /// Reset the coordinator (used when authentication completes)
    func reset() {
        currentFlow = .login
        registrationPath = NavigationPath()
        
        if AppConfig.enableDebugLogging {
            print("🧭 AuthCoordinator: Reset")
        }
    }
    
    // MARK: - Computed Properties
    
    /// Check if currently in registration flow
    var isInRegistrationFlow: Bool {
        currentFlow == .registration
    }
    
    /// Check if we can navigate back in registration flow
    var canGoBackInRegistration: Bool {
        !registrationPath.isEmpty
    }
    
    /// Current depth of the registration stack
    var registrationStackDepth: Int {
        registrationPath.count
    }
}
