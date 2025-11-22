//
//  ServiceFactory.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
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
            return MockAuthService()
        case .staging, .production:
            // TODO: return FirebaseAuthService()
            return MockAuthService()
        }
    }
    
    // MARK: - User Service
    func makeUserService() -> UserServiceProtocol {
        switch AppConfig.environment {
        case .development:
            return MockUserService()
        case .staging, .production:
            // TODO: return FirebaseUserService()
            return MockUserService()
        }
    }
}
