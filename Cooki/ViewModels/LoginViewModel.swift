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
    @Published var displayName = ""
    @Published var isSignUpMode = false
    @Published var showForgotPassword = false
    
    // MARK: - App View Model
    private let appViewModel: AppViewModel
    
    // MARK: - Init
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        if isSignUpMode {
            return !email.isEmpty &&
                   !password.isEmpty &&
                   password.count >= 6 &&
                   isValidEmail(email)
        } else {
            return !email.isEmpty &&
                   !password.isEmpty &&
                   isValidEmail(email)
        }
    }
    
    var buttonTitle: String {
        isSignUpMode ? "Sign Up" : "Sign In"
    }
    
    var toggleModeText: String {
        isSignUpMode ? "Already have an account? Sign In" : "Don't have an account? Sign Up"
    }
    
    // MARK: - Actions
    func handleAuth() async {
        await appViewModel.signUp(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password,
        )
    }
    
    func toggleMode() {
        isSignUpMode.toggle()
        clearForm()
    }
    
    func handleForgotPassword() async {
        await appViewModel.resetPassword(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    // MARK: - Helpers
    private func clearForm() {
        email = ""
        password = ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
