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
    
    // Create unique view ID based on state
    private var viewStateId: String {
        if !appViewModel.isAuthenticated {
            return "auth-flow"
        } else if appViewModel.needsProfileCompletion {
            return "profile-completion"
        } else {
            return "main-app"
        }
    }
    
    var body: some View {
        let _ = print("🎯 RootCoordinator BODY - isAuth: \(appViewModel.isAuthenticated), needsProfile: \(appViewModel.needsProfileCompletion), viewId: \(viewStateId)")
        
        ZStack {
            // Development skip login feature
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                let _ = print("🎯 RootCoordinator - Showing MainView (DEV MODE)")
                MainView()
            }
            // User is not authenticated - show login flow with navigation
            else if !appViewModel.isAuthenticated {
                let _ = print("🎯 RootCoordinator - Showing AuthFlowView")
                AuthFlowView()
                    .environmentObject(authCoordinator)
            }
            // User is authenticated but needs to complete profile
            else if appViewModel.needsProfileCompletion {
                let _ = print("🎯 RootCoordinator - Showing UserDetailsView")
                UserDetailsView()
            }
            // User is fully authenticated with complete profile - show main app
            else {
                let _ = print("🎯 RootCoordinator - Showing MainView")
                MainView()
            }
        }
        .id(viewStateId) // Force view recreation when state changes
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: viewStateId)
        .onChange(of: appViewModel.isAuthenticated) { isAuth in
            print("🎯 RootCoordinator onChange - isAuthenticated: \(isAuth)")
            // Reset auth navigation when authentication state changes
            if isAuth {
                authCoordinator.reset()
            }
        }
        .onChange(of: appViewModel.needsProfileCompletion) { needsProfile in
            print("🎯 RootCoordinator onChange - needsProfileCompletion: \(needsProfile)")
        }
    }
}

// MARK: - Auth Flow View with NavigationStack
struct AuthFlowView: View {
    @EnvironmentObject var authCoordinator: AuthCoordinator
    
    var body: some View {
        NavigationStack(path: $authCoordinator.path) {
            MainLayout(header: {}, content: { LoginContent() })
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .login:
                        MainLayout(header: {}, content: { LoginContent() })
                    case .register:
                        MainLayout(header: { BackHeader() }, content: { RegisterContent() })
                    }
                }
        }
    }
}

struct RootCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        RootCoordinatorView()
            .environmentObject(AppViewModel())
    }
}
