//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//

import SwiftUI

struct RegisterView: View {
    @State private var showSheet: Bool = true
    
    var body: some View {
        ZStack {
            // Purple background
            Color.secondaryPurple
                .ignoresSafeArea()
            
            // Background image (oversized, top-aligned)
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 1.4,
                       height: UIScreen.main.bounds.height * 1.1,
                       alignment: .top)
                .clipped()
                .ignoresSafeArea()
            
            // White modal sheet (always centered)
            ModalSheet(
                heightFraction: 0.85,
                cornerRadius: 27,
                content: {
                    VStack(spacing: 16) {
                        Text("Welcome to Cooki!")
                            .font(.title)
                            .padding()

                        Button("Login") {
                            print("Login tapped")
                        }
                        .padding()
                        .background(Color.accentBurntOrange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                },
                profileImage: Image("ProfilePic"),
                profileSize: 120
            )
            
            // Top-left App Icon (safe area respected, floating above sheet)
            VStack {
                HStack {
                    Image("AppIconMini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(.leading, 100)
                        .padding(.top, 85)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
