//
//  LoginViewModel.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUpMode = false
    @Published var showForgotPassword = false
    
    // MARK: - App View Model
    var appViewModel: AppViewModel
    
    // MARK: - Init
    init(appViewModel: AppViewModel, isSignUpMode: Bool = false) {
        self.appViewModel = appViewModel
        self.isSignUpMode = isSignUpMode
    }
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isSignUpMode {
            return !trimmedEmail.isEmpty &&
                   !password.isEmpty &&
                   password.count >= 6 &&
                   isValidEmail(trimmedEmail)
        } else {
            return !trimmedEmail.isEmpty &&
                   !password.isEmpty &&
                   isValidEmail(trimmedEmail)
        }
    }
    
    var buttonTitle: String {
        isSignUpMode ? "Create Account" : "Login"
    }
    
    var toggleModeText: String {
        isSignUpMode ? "Already have an account? Sign In" : "Don't have an account? Sign Up"
    }
    
    // MARK: - Actions
    func handleAuth() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isSignUpMode {
            print("🔵 LoginViewModel - Calling signUp for: \(trimmedEmail)")
            await appViewModel.signUp(email: trimmedEmail, password: password)
            print("🔵 LoginViewModel - signUp completed. isAuthenticated: \(appViewModel.isAuthenticated)")
        } else {
            print("🔵 LoginViewModel - Calling signIn for: \(trimmedEmail)")
            await appViewModel.signIn(email: trimmedEmail, password: password)
            print("🔵 LoginViewModel - signIn completed. isAuthenticated: \(appViewModel.isAuthenticated)")
        }
    }
    
    func toggleMode() {
        isSignUpMode.toggle()
        clearForm()
    }
    
    func handleForgotPassword() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        await appViewModel.resetPassword(email: trimmedEmail)
    }
    
    // MARK: - Helpers
    private func clearForm() {
        email = ""
        password = ""
        appViewModel.errorMessage = nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
