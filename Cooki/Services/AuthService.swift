//
//  AuthService.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//
import Foundation

actor AuthService {
    static let shared = AuthService()

    func login(email: String, password: String) async throws {
        // Replace with real API call
        print("Logging in with \(email)")
        try await Task.sleep(nanoseconds: 1_000_000_000) // fake delay
    }
}
