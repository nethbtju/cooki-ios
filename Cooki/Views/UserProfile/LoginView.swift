//
//  LoginView.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?

    @State private var navigateToRegisterPage = false
    @State private var navigateToUserDetailsPage = false
    @State private var navigateToHomePage = false
    
    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Purple background
                Color.secondaryPurple
                    .ignoresSafeArea()
                
                // Background image
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 1.4,
                           height: UIScreen.main.bounds.height * 1.1,
                           alignment: .top)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack {
                    // Logo
                    Image("CookieIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 120)
                        .padding(.bottom, 24)
                    
                    // White modal sheet
                    ModalSheet(
                        heightFraction: 0.64,
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Welcome to your new pantry pal!")
                                    .font(AppFonts.heading())
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.trailing, 6)
                                
                                // Email
                                TextField("Email Address", text: $email)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.textGrey)
                                    )
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($focusedField, equals: .email)
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(Color.textGrey)
                                
                                // Password
                                SecureField("Password", text: $password)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.textGrey)
                                    )
                                    .focused($focusedField, equals: .password)
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(Color.textGrey)
                                
                                // Forgot password
                                Button("Forgot password?") {
                                    print("Forgot password tapped")
                                }
                                .font(AppFonts.regularBody())
                                .foregroundColor(.accentColor)
                                
                                // Login button
                                Button(action: { print("Login clicked!") }) {
                                    Text("Login")
                                        .font(AppFonts.buttonFont())
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.accentBurntOrange)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .navigationDestination(isPresented: $navigateToHomePage) {
                                    HomeView()
                                        .navigationBarBackButtonHidden(true)
                                }
                                
                                // Register link
                                HStack(spacing: 4) {
                                    Text("Not a member?")
                                        .foregroundColor(.textGrey)
                                    Button("Register now") {
                                    }
                                    .navigationDestination(isPresented: $navigateToRegisterPage) {
                                        RegisterView()
                                    }
                                    .foregroundColor(.accentBurntOrange)
                                    .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                Divider()
                                    .background(Color.gray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 24)
                                
                                // Social logins
                                VStack(spacing: 12) {
                                    Text("Or continue with")
                                        .foregroundColor(.textGrey)
                                    
                                    HStack(spacing: 12) {
                                        SocialButton(bg: .red, systemIcon: "envelope.fill")
                                        SocialButton(bg: .black, systemIcon: "apple.logo")
                                        SocialButton(bg: .blue, systemIcon: "f.circle.fill")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 48)
                        }
                    )
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
