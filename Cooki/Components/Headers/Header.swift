//
//  Header.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct HomeHeader: View {
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image("CookieMiniIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                
                Text("Hello, Neth")
                    .foregroundColor(.backgroundWhite)
                    .font(AppFonts.heading2())
            }
            Spacer()
            ProfileIcon(image: Image("ProfilePic"), size: 50)
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.horizontal, 24)
    }
}

struct Header: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .font(AppFonts.heading3())
                .foregroundStyle(Color.backgroundWhite)
                .padding(.leading, 24)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}
