//
//  ReceiptProcessingServiceClient.swift
//  Cooki
//
//  Created by Rohit Valanki on 30/11/2025.
//


//
//  ReceiptProcessingServiceClient.swift
//  Cooki
//

import Foundation

class ReceiptProcessingServiceClient {
    static let shared = ReceiptProcessingServiceClient()
    
    private init() {}
    
    func uploadMultipart<T: Decodable>(
        url: URL,
        fileURL: URL,
        responseType: T.Type
    ) async throws -> T {
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Read file data
        guard fileURL.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "FileAccess", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot access file"])
        }
        defer { fileURL.stopAccessingSecurityScopedResource() }
        
        let fileData = try Data(contentsOf: fileURL)
        let fileName = fileURL.lastPathComponent
        let mimeType = getMimeType(for: fileURL)
        
        // Build multipart body
        var body = Data()
        
        // Add file part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: 0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])
        }
        
        // Decode response
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private func getMimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        switch pathExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "pdf":
            return "application/pdf"
        default:
            return "application/octet-stream"
        }
    }
}