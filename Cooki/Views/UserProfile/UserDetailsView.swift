//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//

import SwiftUI

struct UserDetailsView: View {
    @State private var showSheet: Bool = true
    
    @State private var preferredName: String = ""
    @State private var gender: String = ""
    @State private var country: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var dietarypref: String = ""
    
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
                heightFraction: 0.80,
                content: {
                    VStack(spacing: 20) {
                        Text("Hello Cooki 👋")
                            .font(.title)
                            .foregroundColor(.black)
                        Text("This is a preview of the modal sheet.")
                            .foregroundColor(.gray)
                        Button("Test Button") {
                            print("Tapped in preview")
                        }
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 16) {
//                            VStack(alignment: .leading) {
//                                Text("Nice to meet you...")
//                                    .font(AppFonts.heading())
//                            }
//                            .padding(.bottom, 8)
//                            
//                            // Text fields
//                            TextField("Preferred Name", text: $preferredName)
//                                .padding(16)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color.textGrey)
//                                )
//                                .keyboardType(.emailAddress)
//                                .autocapitalization(.none)
//                                .font(AppFonts.lightBody())
//                                .foregroundColor(Color.textGrey)
//                            
//                            TextField("Gender", text: $gender)
//                                .padding(16)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color.textGrey)
//                                )
//                                .keyboardType(.emailAddress)
//                                .autocapitalization(.none)
//                                .font(AppFonts.lightBody())
//                                .foregroundColor(Color.textGrey)
//                            
//                            TextField("Country", text: $country)
//                                .padding(16)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color.textGrey)
//                                )
//                                .keyboardType(.emailAddress)
//                                .autocapitalization(.none)
//                                .font(AppFonts.lightBody())
//                                .foregroundColor(Color.textGrey)
//                            
//                            HStack {
//                                TextField("Height", text: $preferredName)
//                                    .padding(16)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .stroke(Color.textGrey)
//                                    )
//                                    .keyboardType(.emailAddress)
//                                    .autocapitalization(.none)
//                                    .font(AppFonts.lightBody())
//                                    .foregroundColor(Color.textGrey)
//                                
//                                TextField("Weight", text: $preferredName)
//                                    .padding(16)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .stroke(Color.textGrey)
//                                    )
//                                    .keyboardType(.emailAddress)
//                                    .autocapitalization(.none)
//                                    .font(AppFonts.lightBody())
//                                    .foregroundColor(Color.textGrey)
//                            }
//                            
//                            VStack(alignment: .leading, spacing: 8) {
//                                TextField("Dietary Preferences", text: $preferredName)
//                                    .padding(16)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .stroke(Color.textGrey)
//                                    )
//                                    .keyboardType(.emailAddress)
//                                    .autocapitalization(.none)
//                                    .font(AppFonts.lightBody())
//                                    .foregroundColor(Color.textGrey)
//                                
//                                Text("Select one or more")
//                                    .foregroundColor(.textGrey)
//                                    .font(AppFonts.smallBody())
//                                    .contentMargins(-100)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                            
//                            // Get Started
//                            Button(action: { getStarted() }) {
//                                Text("Get Started")
//                                    .font(AppFonts.buttonFont())
//                                    .foregroundColor(.white)  // Text color
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.accentBurntOrange)
//                                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                            }
//                            .padding(.top, 16)
//                        }
//                        .padding(24)
//                    }
                }
            )
            
            // Top-left App Icon (safe area respected, floating above sheet)
            VStack {
                HStack {
                    Image("AppIconMini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(.leading, 100)
                        .padding(.top, 100)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    private func getStarted() {
        print("Clicked get started")
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
