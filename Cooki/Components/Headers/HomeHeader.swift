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
    let onSettingsTap: () -> Void

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
                        Button {
                            onSettingsTap()
                        } label: {
                            ProfileIcon(image: user.profilePicture, size: 150, editable: true)
                        }
                        .buttonStyle(.plain)
                    }
                )
            }
        }
    }
}
