//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//
//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // MARK: Background
            Color.secondaryPurple
                .ignoresSafeArea()
            
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 1.4,
                       height: UIScreen.main.bounds.height * 1.1,
                       alignment: .top)
                .clipped()
                .ignoresSafeArea()
            
            // MARK: Content
            VStack {
                // Header bar
                HStack {
                    // Left side
                    HStack(spacing: 10) {
                        Image("CookieMiniIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                        
                        Text("Hello, Neth")
                            .foregroundColor(.backgroundWhite)
                            .font(AppFonts.heading2())
                    }
                    
                    Spacer().frame(width: 160)
                    
                    // Right side
                    ProfileIcon(image: Image("ProfilePic"), size: 50)
                }
              
                Spacer().frame(height: 28)
                
                // Modal sheet
                ModalSheet(
                    heightFraction: 0.80,
                    cornerRadius: 27,
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hello, Neth")
                                .foregroundColor(.backgroundWhite)
                                .font(AppFonts.heading2())
                        }
                    }
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
