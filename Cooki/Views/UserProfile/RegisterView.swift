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
    @StateObject private var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var confirmPassword: String = ""
    @State private var passwordMismatch: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password, confirmPassword
    }
    
    init() {
        // Initialize with placeholder - will be set in onAppear
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: AppViewModel(), isSignUpMode: true))
    }
    
    // Check if confirm password matches
    private var isConfirmPasswordValid: Bool {
        !confirmPassword.isEmpty && confirmPassword == loginViewModel.password
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
                                text: $loginViewModel.email,
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
                                text: $loginViewModel.password,
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
                            isEnabled: loginViewModel.isFormValid && isConfirmPasswordValid && !appViewModel.isLoading
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
                                dismiss()
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
        .onAppear {
            // Sync the loginViewModel with the environment's appViewModel
            loginViewModel.appViewModel = appViewModel
            loginViewModel.isSignUpMode = true
            
            // Clear any previous errors when entering register view
            appViewModel.errorMessage = nil
            passwordMismatch = false
            
            print("🔵 RegisterView appeared")
        }
    }
    
    private func register() async {
        // Reset error states
        passwordMismatch = false
        appViewModel.errorMessage = nil
        
        // Check password match first
        guard loginViewModel.password == confirmPassword else {
            passwordMismatch = true
            appViewModel.errorMessage = "Passwords do not match"
            print("🔴 RegisterView - Passwords do not match")
            return
        }
        
        print("🔵 RegisterView - Starting registration...")
        print("🔵 RegisterView - Email: \(loginViewModel.email)")
        
        // Use the loginViewModel's handleAuth which will call signUp
        await loginViewModel.handleAuth()
        
        print("🔵 RegisterView - Registration completed. isAuthenticated: \(appViewModel.isAuthenticated)")
        print("🔵 RegisterView - needsProfileCompletion: \(appViewModel.needsProfileCompletion)")
        
        // Root coordinator will automatically navigate to UserDetailsView
        // when needsProfileCompletion becomes true
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
