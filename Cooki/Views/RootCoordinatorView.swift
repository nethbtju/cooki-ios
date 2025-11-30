//
//  RootCoordinatorView.swift
//  Cooki
//
//  Root coordinator that manages authentication state and navigation
//

import SwiftUI

struct RootCoordinatorView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var authCoordinator = AuthCoordinator()
    
    var body: some View {
        let _ = print("🎯 RootCoordinator BODY - isAuth: \(appViewModel.isAuthenticated), needsProfile: \(appViewModel.needsProfileCompletion)")
        
        Group {
            // Development skip login feature
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                let _ = print("🎯 RootCoordinator - Showing MainView (DEV MODE)")
                MainView()
            }
            // User is authenticated but needs to complete profile
            else if appViewModel.isAuthenticated && appViewModel.needsProfileCompletion {
                let _ = print("🎯 RootCoordinator - Showing AuthFlowView with UserDetails")
                AuthFlowView()
                    .environmentObject(authCoordinator)
            }
            // User is not authenticated - show auth flow with navigation
            else if !appViewModel.isAuthenticated {
                let _ = print("🎯 RootCoordinator - Showing AuthFlowView")
                AuthFlowView()
                    .environmentObject(authCoordinator)
            }
            // User is fully authenticated with complete profile - show main app
            else {
                let _ = print("🎯 RootCoordinator - Showing MainView")
                MainView()
            }
        }
        .onChange(of: appViewModel.isAuthenticated) { isAuth in
            print("🎯 RootCoordinator onChange - isAuthenticated: \(isAuth)")
        }
        .onChange(of: appViewModel.needsProfileCompletion) { needsProfile in
            print("🎯 RootCoordinator onChange - needsProfileCompletion: \(needsProfile)")
            
            // Push UserDetailsView when profile completion is needed
            if needsProfile && appViewModel.isAuthenticated {
                authCoordinator.pushUserDetails()
            } else if !needsProfile && appViewModel.isAuthenticated {
                // Profile completed, clear the stack
                authCoordinator.reset()
            }
        }
    }
}

// MARK: - Auth Flow with Single NavigationStack
struct AuthFlowView: View {
    @EnvironmentObject var authCoordinator: AuthCoordinator
    
    var body: some View {
        NavigationStack(path: $authCoordinator.path) {
            // Root: LoginView
            MainLayout(
                header: {},
                content: { LoginContent() }
            )
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .login:
                    MainLayout(
                        header: {},
                        content: { LoginContent() }
                    )
                    
                case .register:
                    MainLayout(
                        header: { BackHeader() },
                        content: { RegisterContent() }
                    )
                    
                case .userDetails:
                    UserDetailsView()
                }
            }
        }
    }
}
