//
//  RootCoordinatorView.swift
//  Cooki
//
//  Root coordinator that manages authentication state and navigation
//

import SwiftUI

struct RootCoordinatorView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            // Development skip login feature
            if AppConfig.skipLoginInDevelopment && AppConfig.environment == .development {
                MainView()
            }
            // User is not authenticated - show login flow
            else if !appViewModel.isAuthenticated {
                LoginView()
            }
            // User is authenticated but needs to complete profile
            else if appViewModel.needsProfileCompletion {
                NavigationStack {
                    UserDetailsView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            // User is fully authenticated with complete profile - show main app
            else {
                MainView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appViewModel.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: appViewModel.needsProfileCompletion)
        .onAppear {
            if AppConfig.enableDebugLogging {
                print("🎯 RootCoordinator - State:")
                print("   isAuthenticated: \(appViewModel.isAuthenticated)")
                print("   needsProfileCompletion: \(appViewModel.needsProfileCompletion)")
                print("   currentUser: \(appViewModel.currentUser?.displayName ?? "nil")")
            }
        }
        .onChange(of: appViewModel.isAuthenticated) { newValue in
            if AppConfig.enableDebugLogging {
                print("🎯 RootCoordinator - isAuthenticated changed to: \(newValue)")
            }
        }
        .onChange(of: appViewModel.needsProfileCompletion) { newValue in
            if AppConfig.enableDebugLogging {
                print("🎯 RootCoordinator - needsProfileCompletion changed to: \(newValue)")
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
