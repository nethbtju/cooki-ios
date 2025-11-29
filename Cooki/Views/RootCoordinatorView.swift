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
            return "auth-flow-\(authCoordinator.currentFlow)"
        } else if appViewModel.needsProfileCompletion {
            return "profile-completion"
        } else {
            return "main-app"
        }
    }
    
    var body: some View {
        let _ = print("🎯 RootCoordinator BODY - isAuth: \(appViewModel.isAuthenticated), needsProfile: \(appViewModel.needsProfileCompletion), flow: \(authCoordinator.currentFlow)")
        
        ZStack {
            // Development skip login feature
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                let _ = print("🎯 RootCoordinator - Showing MainView (DEV MODE)")
                MainView()
            }
            // User is authenticated but needs to complete profile (takes precedence)
            else if appViewModel.isAuthenticated && appViewModel.needsProfileCompletion {
                let _ = print("🎯 RootCoordinator - Showing UserDetailsView")
                UserDetailsView()
            }
            // User is not authenticated - show appropriate flow
            else if !appViewModel.isAuthenticated {
                switch authCoordinator.currentFlow {
                case .login:
                    let _ = print("🎯 RootCoordinator - Showing LoginFlow")
                    LoginFlowView()
                        .environmentObject(authCoordinator)
                        
                case .registration:
                    let _ = print("🎯 RootCoordinator - Showing RegistrationFlow")
                    RegistrationFlowView()
                        .environmentObject(authCoordinator)
                }
            }
            // User is fully authenticated with complete profile - show main app
            else {
                let _ = print("🎯 RootCoordinator - Showing MainView")
                MainView()
            }
        }
        .id(viewStateId)
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

// MARK: - Login Flow (No Navigation Stack)
struct LoginFlowView: View {
    @EnvironmentObject var authCoordinator: AuthCoordinator
    
    var body: some View {
        MainLayout(
            header: {},
            content: { LoginContent() }
        )
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Registration Flow (Separate Navigation Stack)
struct RegistrationFlowView: View {
    @EnvironmentObject var authCoordinator: AuthCoordinator
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack(path: $authCoordinator.registrationPath) {
            // Root of registration stack - Register screen with NO back button
            MainLayout(
                header: { BackHeader(action: authCoordinator.returnToLogin) },
                content: { RegisterContent() }
            )
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: RegistrationRoute.self) { route in
                switch route {
                case .register:
                    // This shouldn't be called as register is the root
                    MainLayout(
                        header: { BackHeader(action: authCoordinator.returnToLogin) },
                        content: { RegisterContent() }
                    )
                    
                case .userDetails:
                    // User details shown after registration completes
                    UserDetailsView()
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
