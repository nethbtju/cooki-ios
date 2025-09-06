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

    enum Field {
        case email, password
    }

    var body: some View {
        VStack(spacing: 0) {
            // Logo
            Image("CookieIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 220)
                .padding(.top, 96)
                .padding(.bottom, 36)

            // Card
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome to your new pantry pal!")
                    .font(AppFonts.heading())
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true) // allow vertical expansion
                    .padding(.trailing, 10)

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
                SecureField("Password", text: $email)
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

                // Forgot password
                Button("Forgot password?") {
                    print("Forgot password tapped")
                }
                .font(AppFonts.regularBody())
                .foregroundColor(.accentColor)

                // Login button
                Button(action: { login() }) {
                    Text("Login")
                        .font(AppFonts.buttonFont())
                        .foregroundColor(.white)  // Text color
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentBurntOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Register link
                HStack(spacing: 4) {
                    Text("Not a member?")
                        .foregroundColor(.textGrey)
                    Button("Register now") {
                        print("Register tapped")
                    }
                    .foregroundColor(.accentBurntOrange)
                    .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .center)

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
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .background(Color.secondary)
    }
    
    private func login() {
        Task {
            do {
                try await AuthService.shared.login(email: email, password: password)
            } catch {
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPhone 15 Pro")   // optional: pick device
            .preferredColorScheme(.light)     // optional: light/dark mode
    }
}
