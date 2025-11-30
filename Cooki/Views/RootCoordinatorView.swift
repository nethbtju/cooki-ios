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
        ZStack {
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                // Development: Skip login
                MainView()
                    .transition(.opacity)
            } else if !appViewModel.isAuthenticated || appViewModel.needsProfileCompletion {
                // Show auth flow for: not authenticated OR needs profile completion
                AuthFlowView()
                    .environmentObject(authCoordinator)
                    .transition(.opacity)
                    .onAppear {
                        // Push UserDetails if needed when AuthFlowView appears
                        if appViewModel.isAuthenticated && appViewModel.needsProfileCompletion {
                            print("🎯 AuthFlowView appeared - pushing UserDetails")
                            authCoordinator.pushUserDetails()
                        }
                    }
            } else {
                // Fully authenticated with complete profile
                MainView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appViewModel.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: appViewModel.needsProfileCompletion)
        .onChange(of: appViewModel.needsProfileCompletion) { needsProfile in
            print("🎯 onChange needsProfile: \(needsProfile), isAuth: \(appViewModel.isAuthenticated)")
            // Push UserDetailsView when profile completion is needed
            if needsProfile && appViewModel.isAuthenticated {
                print("🎯 Pushing UserDetails from onChange")
                authCoordinator.pushUserDetails()
            } else if !needsProfile && appViewModel.isAuthenticated {
                print("🎯 Resetting navigation from onChange")
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
            LoginView()
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: AuthRoute.self) { route in
                    viewForRoute(route)
                }
        }
    }
    
    @ViewBuilder
    private func viewForRoute(_ route: AuthRoute) -> some View {
        switch route {
        case .login:
            LoginView()
            
        case .register:
            RegisterView()
            
        case .userDetails:
            UserDetailsView()
        }
    }
}
