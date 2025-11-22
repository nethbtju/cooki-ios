//
//  LoginView.swift
//  Cooki
//
//  Modified by Neth Botheju on 22/11/2025.
//

import SwiftUI

struct LoginView: View {
    // 1. Inject the ViewModels
    @EnvironmentObject var appViewModel: AppViewModel  // Global app state
    @StateObject private var loginViewModel: LoginViewModel  // Form logic
    
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password, firstName, lastName
    }
    
    // 2. Initialize LoginViewModel with AppViewModel
    init(appViewModel: AppViewModel) {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: appViewModel))
    }
    
    // Required for EnvironmentObject injection
    init() {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: AppViewModel()))
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
                        heightFraction: loginViewModel.isSignUpMode ? 0.75 : 0.64,
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(loginViewModel.isSignUpMode ? "Join the Cooki family!" : "Welcome to your pantry pal!")
                                    .font(AppFonts.heading())
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.trailing, 6)
                                
                                // Sign up fields (shown only in sign-up mode)
                                if loginViewModel.isSignUpMode {
                                    TextField("First Name", text: $loginViewModel.firstName)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.textGrey)
                                        )
                                        .autocapitalization(.words)
                                        .focused($focusedField, equals: .firstName)
                                        .font(AppFonts.lightBody())
                                        .foregroundColor(Color.textGrey)
                                    
                                    TextField("Last Name", text: $loginViewModel.lastName)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.textGrey)
                                        )
                                        .autocapitalization(.words)
                                        .focused($focusedField, equals: .lastName)
                                        .font(AppFonts.lightBody())
                                        .foregroundColor(Color.textGrey)
                                }
                                
                                // Email - 3. Bind to ViewModel property
                                TextField("Email Address", text: $loginViewModel.email)
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
                                
                                // Password - 3. Bind to ViewModel property
                                SecureField("Password", text: $loginViewModel.password)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.textGrey)
                                    )
                                    .focused($focusedField, equals: .password)
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(Color.textGrey)
                                
                                // Password hint for sign-up
                                if loginViewModel.isSignUpMode {
                                    Text("Password must be at least 6 characters")
                                        .font(AppFonts.smallBody())
                                        .foregroundColor(Color.textGrey.opacity(0.7))
                                        .padding(.horizontal, 4)
                                }
                                
                                // Forgot password (login mode only)
                                if !loginViewModel.isSignUpMode {
                                    Button("Forgot password?") {
                                        Task {
                                            await loginViewModel.handleForgotPassword()
                                        }
                                    }
                                    .font(AppFonts.regularBody())
                                    .foregroundColor(.accentColor)
                                }
                                
                                // 4. Show error message from ViewModel
                                if let error = appViewModel.errorMessage {
                                    Text(error)
                                        .font(AppFonts.smallBody())
                                        .foregroundColor(.textRed)
                                        .padding(.horizontal, 4)
                                }
                                
                                // 5. Call ViewModel method with async action
                                Button(action: {
                                    Task {
                                        await loginViewModel.handleAuth()
                                    }
                                }) {
                                    ZStack {
                                        Text(loginViewModel.isSignUpMode ? "Sign Up" : "Login")
                                            .font(AppFonts.buttonFont())
                                            .foregroundColor(.white)
                                            .opacity(appViewModel.isLoading ? 0 : 1)
                                        
                                        // 6. Show loading indicator from ViewModel
                                        if appViewModel.isLoading {
                                            ProgressView()
                                                .tint(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(loginViewModel.isFormValid ? Color.accentBurntOrange : Color.textGrey.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(!loginViewModel.isFormValid || appViewModel.isLoading)
                                
                                // Toggle between login/signup
                                // Toggle between login/signup
                                HStack(spacing: 4) {
                                    Text("Not a member?")
                                        .foregroundColor(.textGrey)
                                    NavigationLink(destination: RegisterView()) {
                                        Text("Register now")
                                            .foregroundColor(.accentBurntOrange)
                                            .fontWeight(.medium)
                                    }
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
                                        IconButton.google(action: { print("Tapped Google")})
                                        IconButton.apple(action: { print("Tapped Apple")})
                                        IconButton.facebook(action: { print("Tapped Facebook")})
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
            .environmentObject(AppViewModel())
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
