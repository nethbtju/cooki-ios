//
//  CookiLaunchScreenView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/12/2025.
//
import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color("SecondaryColor")

            Image("AppIconMini") // from Assets
                .resizable()
                .scaledToFit()
                .frame(width: 180) // adjust as needed
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
