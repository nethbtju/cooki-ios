//
//  ReceiptService.swift
//  Cooki
//
//  Created by Rohit Valanki on 30/11/2025.
//

import Foundation

struct ReceiptProcessingService {
    func processReceipt(fileURL: URL) async throws -> ReceiptData {
        let endpoint = URL(string: "http://192.168.4.25:8000/parse-receipt/woolworths/")!
        
        return try await ReceiptProcessingServiceClient.shared.uploadMultipart(
            url: endpoint,
            fileURL: fileURL,
            responseType: ReceiptData.self
        )
    }
}
