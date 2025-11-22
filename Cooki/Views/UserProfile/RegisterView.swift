//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var loginViewModel: LoginViewModel
    
    @State private var confirmPassword: String = ""
    @State private var passwordMismatch: Bool = false
    @FocusState private var focusedField: Field?
    
    @State private var navigateToNext: Bool = false
    
    enum Field {
        case email, password, confirmPassword
    }
    
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
                        heightFraction: 0.65,
                        content: {
                            ScrollView(.vertical, showsIndicators: false) {
                                Spacer().padding(.bottom, 24)
                                
                                VStack(alignment: .leading, spacing: 24) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Let's get you registered!")
                                            .font(AppFonts.heading())
                                            .multilineTextAlignment(.leading)
                                            .padding(.trailing, 10)
                                        
                                        // Email
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
                                        
                                        // Password
                                        SecureField("Password", text: $loginViewModel.password)
                                            .padding(16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.textGrey)
                                            )
                                            .focused($focusedField, equals: .password)
                                            .font(AppFonts.lightBody())
                                            .foregroundColor(Color.textGrey)
                                        
                                        // Confirm Password
                                        SecureField("Confirm Password", text: $confirmPassword)
                                            .padding(16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.textGrey)
                                            )
                                            .focused($focusedField, equals: .confirmPassword)
                                            .font(AppFonts.lightBody())
                                            .foregroundColor(Color.textGrey)
                                        
                                        // Error message
                                        if passwordMismatch {
                                            Text("Passwords do not match")
                                                .foregroundColor(.red)
                                                .font(AppFonts.smallBody())
                                        }
                                        
                                        if let error = appViewModel.errorMessage {
                                            Text(error)
                                                .foregroundColor(.red)
                                                .font(AppFonts.smallBody())
                                        }
                                    }
                                    
                                    // Register button
                                    Button(action: {
                                        Task {
                                            await register()
                                        }
                                    }) {
                                        Text("Register")
                                            .font(AppFonts.buttonFont())
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.accentBurntOrange)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .navigationDestination(isPresented: $navigateToNext) {
                                        UserDetailsView()
                                    }
                                    .padding(.top, 24)
                                }
                                .padding(24)
                            }
                        }
                    )
                }
            }
        }
    }
    
    private func register() async {
        // Check password match first
        guard loginViewModel.password == confirmPassword else {
            passwordMismatch = true
            return
        }
        
        passwordMismatch = false
        
        // Need first and last name for signup - navigate to UserDetailsView first
        navigateToNext = true
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AppViewModel())
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
