//
//  ServiceFactory.swift
//  Cooki
//
//  Modified by Neth Botheju on 22/11/2025.
//
import Foundation

class ServiceFactory {
    static let shared = ServiceFactory()
    
    enum Environment {
        case development
        case staging
        case production
    }
    
    private init() {}
    
    // MARK: - Auth Service
    func makeAuthService() -> AuthServiceProtocol {
        switch AppConfig.environment {
        case .development:
            // Use Firebase in development now
            return FirebaseAuthService()
        case .staging, .production:
            return FirebaseAuthService()
        }
    }
    
    // MARK: - User Service
    func makeUserService() -> UserServiceProtocol {
        switch AppConfig.environment {
        case .development:
            return FirebaseUserService() // Create this next
        case .staging, .production:
            return FirebaseUserService()
        }
    }
    
    // MARK: - Pantry Service
    func makePantryService() -> PantryServiceProtocol {
        switch AppConfig.environment {
        case .development, .staging, .production:
            return FirebasePantryService()
        }
    }
}
