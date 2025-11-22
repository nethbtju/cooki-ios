//
//  UploadReceiptHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

struct UploadReceiptHeader: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        AppHeader(
            padding: EdgeInsets(top: 10, leading: 20, bottom: 16, trailing: 20),
            leading: {
                BackButton(action: { dismiss() })
            },
            trailing: {
                IconButton(systemIcon: "info.circle", backgroundColor: .clear, action: {})
            }
        )
    }
}
