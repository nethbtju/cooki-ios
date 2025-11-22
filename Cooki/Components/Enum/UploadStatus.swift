//
//  UploadStatus.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
// MARK: - Upload Status
enum UploadStatus: String, Codable {
    case pending = "Pending"
    case uploading = "Uploading"
    case processing = "Processing"
    case success = "Success"
    case failed = "Failed"
    case cancelled = "Cancelled"
    
    var icon: String {
        switch self {
        case .pending: return "clock"
        case .uploading: return "arrow.up.circle"
        case .processing: return "gearshape.2"
        case .success: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .cancelled: return "xmark.circle"
        }
    }
    
    var isComplete: Bool {
        self == .success || self == .failed || self == .cancelled
    }
    
    var isInProgress: Bool {
        self == .uploading || self == .processing
    }
}
