//
//  LoginView.swift
//  Cooki
//
//  Modified by Neth Botheju on 22/11/2025.
//

import SwiftUI

struct LoginContent: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var authCoordinator: AuthCoordinator
    @StateObject private var loginViewModel: LoginViewModel
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    init() {
        // Initialize with a placeholder - will be set in onAppear
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: AppViewModel(), isSignUpMode: false))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Logo
            Image("CookieIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 180)
                .padding(.top, 30)
                .padding(.bottom, 24)
            
            // White modal
            ZStack {
                Color.white
                    .clipShape(TopRoundedModal())
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back!")
                                .font(AppFonts.heading())
                                .foregroundStyle(.text)
                            
                            Text("Sign in to continue")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                        }.padding(.top, 12)
                        
                        // Form Fields
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
                                placeholder: "Password",
                                text: $loginViewModel.password,
                                textContentType: .password,
                                isSecure: true
                            )
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit {
                                focusedField = nil
                                Task {
                                    await loginViewModel.handleAuth()
                                }
                            }
                        }.padding(.top, 12)
                        
                        // Forgot password
                        Button("Forgot password?") {
                            Task {
                                await loginViewModel.handleForgotPassword()
                            }
                        }
                        .font(AppFonts.regularBody())
                        .foregroundColor(.accentBurntOrange)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 4)
                        .padding(.top, 6)
                        
                        // Error message
                        if let error = appViewModel.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 14))
                                Text(error)
                                    .font(AppFonts.smallBody())
                            }
                            .foregroundColor(.textRed)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.textRed.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Login button using PrimaryButton
                        PrimaryButton.primary(
                            title: appViewModel.isLoading ? "" : "Login",
                            action: {
                                focusedField = nil
                                Task {
                                    await loginViewModel.handleAuth()
                                }
                            },
                            isEnabled: loginViewModel.isFormValid && !appViewModel.isLoading
                        )
                        .overlay {
                            if appViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Register link
                        HStack(spacing: 4) {
                            Text("Not a member?")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                            Button {
                                authCoordinator.push(.register)
                            } label: {
                                Text("Register now")
                                    .font(AppFonts.regularBody())
                                    .foregroundColor(.accentBurntOrange)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.textGrey.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("OR")
                                .font(AppFonts.smallBody())
                                .foregroundColor(.textGrey)
                                .padding(.horizontal, 12)
                            
                            Rectangle()
                                .fill(Color.textGrey.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Social logins
                        VStack(spacing: 12) {
                            Text("Continue with")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                            
                            HStack(spacing: 16) {
                                IconButton.google(action: {
                                    print("Google login tapped")
                                })
                                IconButton.apple(action: {
                                    print("Apple login tapped")
                                })
                                IconButton.facebook(action: {
                                    print("Facebook login tapped")
                                })
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            // Sync with environment's appViewModel
            loginViewModel.appViewModel = appViewModel
            loginViewModel.isSignUpMode = false
            
            // Clear any previous errors when returning to login
            appViewModel.errorMessage = nil
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginContent()
            .environmentObject(AppViewModel())
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
