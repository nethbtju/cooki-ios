//
//  HomeHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI
// MARK: - Preset Headers
struct HomeHeader: View {
    let user: User
    
    var body: some View {
        AppHeader(
            leading: {
                HStack(spacing: 10) {
                    Image("CookieMiniIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    
                    Text("\(user.greeting)")
                        .foregroundColor(.backgroundWhite)
                        .font(AppFonts.heading2())
                }
            },
            trailing: {
                ProfileIcon(image: user.getProfilePicture, size: 50)
            }
        )
    }
}
