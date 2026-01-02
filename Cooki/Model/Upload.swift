//
//  UploadItem.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//  Modified by Neth Botheju on 22/11/2025.
//

import Foundation

// MARK: - Upload Item Model
struct Upload: Identifiable, Codable, Equatable {
    let id: UUID
    var fileName: String
    var fileURL: URL?        // Added property for local file URL
    var fileSize: Int64?     // in bytes
    var status: UploadStatus
    var progress: Double     // 0.0 to 1.0
    var uploadedDate: Date?
    var errorMessage: String?
    var detectedItems: [Item]
    
    init(
        id: UUID = UUID(),
        fileName: String,
        fileURL: URL? = nil,   // default nil
        fileSize: Int64? = nil,
        status: UploadStatus = .pending,
        progress: Double = 0.0,
        uploadedDate: Date? = nil,
        errorMessage: String? = nil,
        detectedItems: [Item] = []
    ) {
        self.id = id
        self.fileName = fileName
        self.fileURL = fileURL
        self.fileSize = fileSize
        self.status = status
        self.progress = min(max(progress, 0.0), 1.0) // Clamp between 0 and 1
        self.uploadedDate = uploadedDate
        self.errorMessage = errorMessage
        self.detectedItems = detectedItems
    }
    
    // MARK: - Computed Properties
    var formattedFileSize: String? {
        guard let fileSize = fileSize else { return nil }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
    
    var progressPercentage: Int {
        Int(progress * 100)
    }
}
