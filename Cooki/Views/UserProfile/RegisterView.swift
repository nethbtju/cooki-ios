//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//  Modified by Neth Botheju on 23/11/2025.
//
import SwiftUI

public struct RegisterView: View {
    public var body: some View {
        MainLayout(header: { BackHeader() }, content: { RegisterContent() })
            .navigationBarHidden(true)
    }
}

struct RegisterContent: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var displayName: String = ""
    
    @State private var passwordMismatch: Bool = false
    @FocusState private var focusedField: Field?
    
    @State private var navigateToUserDetails: Bool = false
    
    enum Field {
        case displayName, email, password, confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Cookie logo
            Image("CookieIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 180)
                .padding(.top, 40)
                .padding(.bottom, 24)
            
            // White modal
            ZStack {
                Color.white
                    .clipShape(TopRoundedModal())
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Let's get you registered!")
                                .font(AppFonts.heading())
                                .foregroundStyle(.text)
                                .multilineTextAlignment(.leading)
                            
                            Text("Create your account to get started")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                        }
                        .padding(.top, 12)
                        
                        // Form Fields using FormTextField
                        VStack(spacing: 16) {
                            
                            // Email
                            FormTextField(
                                placeholder: "Email Address",
                                text: $email,
                                keyboardType: .emailAddress,
                                textContentType: .emailAddress,
                                autocapitalization: .never
                            )
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                            
                            // Password
                            FormTextField(
                                placeholder: "Password (min 6 characters)",
                                text: $password,
                                textContentType: .newPassword,
                                isSecure: true
                            )
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .confirmPassword }
                            
                            // Confirm Password
                            FormTextField(
                                placeholder: "Confirm Password",
                                text: $confirmPassword,
                                textContentType: .newPassword,
                                isSecure: true
                            )
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.go)
                            .onSubmit {
                                focusedField = nil
                                Task { await register() }
                            }
                        }
                        .padding(.top, 12)
                        
                        // Error messages
                        if passwordMismatch {
                            ErrorMessageView(
                                message: "Passwords do not match",
                                icon: "exclamationmark.triangle.fill"
                            )
                        }
                        
                        if let error = appViewModel.errorMessage {
                            ErrorMessageView(
                                message: error,
                                icon: "exclamationmark.triangle.fill"
                            )
                        }
                        
                        // Register button using PrimaryButton
                        PrimaryButton.primary(
                            title: appViewModel.isLoading ? "" : "Create Account",
                            action: {
                                focusedField = nil
                                Task { await register() }
                            },
                            isEnabled: isFormValid && !appViewModel.isLoading
                        )
                        .overlay {
                            if appViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Sign in link
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                            Button(action: {
                                // Navigate back (pop to login)
                            }) {
                                Text("Sign In")
                                    .font(AppFonts.regularBody())
                                    .foregroundColor(.accentBurntOrange)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToUserDetails) {
            UserDetailsView()
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password.count >= 6 &&
        isValidEmail(email)
    }
    
    private func register() async {
        // Check password match first
        guard password == confirmPassword else {
            passwordMismatch = true
            return
        }
        
        passwordMismatch = false
        
        // Sign up with Firebase Auth (creates auth account only)
        await appViewModel.signUp(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
        
        // If successful, navigate to UserDetailsView to complete registration
        if appViewModel.isAuthenticated {
            navigateToUserDetails = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Error Message Component
struct ErrorMessageView: View {
    let message: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(message)
                .font(AppFonts.smallBody())
        }
        .foregroundColor(.textRed)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.textRed.opacity(0.1))
        .cornerRadius(8)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
                .environmentObject(AppViewModel())
        }
        .previewDevice("iPhone 15 Pro")
        .preferredColorScheme(.light)
    }
}
