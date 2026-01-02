//
//  UploadCard.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//

import SwiftUI

/// Card for displaying file upload progress and status
struct UploadCard: View {
    let item: Upload
    let onRetry: (() -> Void)?
    let onDelete: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            statusIcon
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.fileName)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                
                statusContent
            }
            
            Spacer()
            
            actionButtons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 1)
        )
        .cornerRadius(22)
    }
    
    // MARK: - Status Icon
    private var statusIcon: some View {
        let config = StatusBadgeConfiguration.uploadStatus(item.status)
        
        return ZStack {
            Circle()
                .fill(config.backgroundColor)
                .frame(width: 44, height: 44)
            
            Image(systemName: config.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(config.iconColor)
        }
    }
    
    // MARK: - Status Content
    @ViewBuilder
    private var statusContent: some View {
        switch item.status {
        case .pending:
            Text("Waiting to upload...")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            
        case .uploading:
            VStack(alignment: .leading, spacing: 4) {
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(Color.secondaryPurple)
                            .frame(
                                width: max(0, min(1, item.progress)) * geo.size.width,
                                height: 8
                            )
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: item.progress)
                    }
                }
                .frame(height: 8)
                
                Text("\(Int(item.progress * 100))%")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            }
            
        case .processing:
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Processing...")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            }
            
        case .success:
            Text("Uploaded successfully!")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.20, green: 0.78, blue: 0.35))
            
        case .failed:
            Text(item.errorMessage ?? "Could not be uploaded!")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 1.0, green: 0.23, blue: 0.19))
            
        case .cancelled:
            Text("Upload cancelled")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
        }
    }
    
    // MARK: - Action Buttons
    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 10) {
            if item.status == .failed, let retry = onRetry {
                circleButton(
                    icon: "arrow.clockwise",
                    backgroundColor: Color(red: 213/255, green: 228/255, blue: 240/255),
                    iconColor: Color(red: 108/255, green: 178/255, blue: 231/255),
                    action: retry
                )
            }
            
            if let delete = onDelete {
                circleButton(
                    icon: "xmark",
                    backgroundColor: Color(red: 0.89, green: 0.89, blue: 0.89),
                    iconColor: Color(red: 0.42, green: 0.42, blue: 0.44),
                    action: delete
                )
            }
        }
    }
    
    private func circleButton(icon: String, backgroundColor: Color, iconColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 28, height: 28)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
        }
    }
}

// MARK: - Upload List Container
struct UploadCardList: View {
    @Binding var uploads: [Upload]
    let onRetryFile: ((UUID) -> Void)?
    
    var body: some View {
        VStack(spacing: 14) {
            ForEach(uploads) { item in
                UploadCard(
                    item: item,
                    onRetry: onRetryFile != nil ? { onRetryFile?(item.id) } : nil,
                    onDelete: { delete(item) }
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.9).combined(with: .opacity).combined(with: .move(edge: .top)),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: uploads.count)
    }
    
    private func delete(_ item: Upload) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            uploads.removeAll { $0.id == item.id }
        }
    }
}

// MARK: - Preview
struct UploadCard_Previews: PreviewProvider {
    static var previews: some View {
        UploadCardList(
            uploads: .constant([
                Upload(fileName: "ReciptName1.png", status: .uploading, progress: 0.7),
                Upload(fileName: "ReciptNameSuccessful.png", status: .success),
                Upload(fileName: "FailedUploadFile.pdf", status: .failed)
            ]),
            onRetryFile: nil
        )
        .padding()
    }
}
