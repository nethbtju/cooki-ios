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

            Spacer(minLength: 16)

            // Card
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome to your new pantry pal!")
                    .font(AppFonts.heading())
                    .padding(.trailing, 40)

                // Email
                TextField("Email Address", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                    .font(AppFonts.lightBody())

                // Password
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .password)
                    .font(AppFonts.lightBody())

                // Forgot password
                Button("Forgot password?") {
                    print("Forgot password tapped")
                }
                .font(AppFonts.lightBody())
                .foregroundColor(.accentColor)

                // Login button
                Button(action: { login() }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.secondary)
                        .foregroundColor(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .font(AppFonts.regularBody().bold())
                }

                // Register link
                HStack(spacing: 4) {
                    Text("Not a member?")
                        .foregroundColor(.gray)
                    Button("Register now") {
                        print("Register tapped")
                    }
                    .foregroundColor(.accentColor)
                    .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Divider().padding(.vertical, 8)

                // Social logins
                VStack(spacing: 12) {
                    Text("Or continue with")
                        .foregroundColor(.gray)

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
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .background(Color.secondary.ignoresSafeArea())
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
