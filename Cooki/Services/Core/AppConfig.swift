//
//  AppConfig.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import Foundation

struct AppConfig {
    // MARK: - Environment
    static var environment: ServiceFactory.Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    // MARK: - Feature Flags
    static let enableDebugLogging = true
    static let useMockData = false
    
    // MARK: - API Configuration
    static let apiTimeout: TimeInterval = 30
    static let maxImageUploadSize = 5_000_000 // 5MB
    
    // MARK: - Debug Settings
    static let skipLoginInDevelopment = false  // Toggle this as needed
}
