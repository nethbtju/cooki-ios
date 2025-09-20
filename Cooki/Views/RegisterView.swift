//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @FocusState private var focusedField: Field?
    
    @State private var navigateToNext: Bool = false
    @State private var errorMessage: String? = nil
    
    enum Field {
        case email, password, confirmPassword
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
                        heightFraction: 0.55,
                        cornerRadius: 27,
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
                                        if let errorMessage = errorMessage {
                                            Text(errorMessage)
                                                .foregroundColor(.red)
                                                .font(AppFonts.smallBody())
                                        }
                                    }
                                    
                                    // Register button
                                    Button(action: { register() }) {
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
    
    private func register() {
        // ✅ Check password match first
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        Task {
            do {
                try await AuthService.shared.login(email: email, password: password)
                
                // Clear error if successful
                errorMessage = nil
                
                DispatchQueue.main.async {
                    navigateToNext = true
                }
            } catch {
                errorMessage = "Registration failed: \(error.localizedDescription)"
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
