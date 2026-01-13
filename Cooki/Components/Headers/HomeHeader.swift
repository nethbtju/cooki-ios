//
//  HomeHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//

import SwiftUI

struct HomeHeader: View {
    let user: User
    let authService: FirebaseAuthService

    @State private var isLoggedOut = false

    var body: some View {
        ZStack {
            if isLoggedOut {
                LoginView()
            } else {
                AppHeader(
                    leading: {
                        HStack(spacing: 10) {
                            Image("CookieMiniIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)

                            Text(user.greeting)
                                .foregroundColor(.backgroundWhite)
                                .font(AppFonts.heading2())
                        }
                    },
                    trailing: {
                        user.getProfilePicture(size: 50)
                    }
                )
            }
        }
    }

    // MARK: - Logout

    private func logout() {
        do {
            try authService.signOut()
            CurrentUser.shared.reset()   // 🔥 REQUIRED
            isLoggedOut = true
            print("✅ User logged out")
        } catch {
            print("❌ Logout failed:", error)
        }
    }
}
