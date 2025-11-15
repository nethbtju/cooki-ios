import SwiftUI

struct UploadItem: Identifiable {
    let id = UUID()
    var fileName: String
    var status: UploadStatus
    var progress: Double = 0
}

enum UploadStatus {
    case uploading
    case success
    case failed
}

struct FileUploadRow: View {
    var item: UploadItem
    var onRetry: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            iconCircle

            VStack(alignment: .leading, spacing: 6) {
                Text(item.fileName)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)

                statusSection
            }

            Spacer()

            rightButtons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97)) // #F7F7F7
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 1) // #E4E4E4
        )
        .cornerRadius(22)
    }

    // MARK: - Left Icon Circle

    private var iconCircle: some View {
        ZStack {
            Circle()
                .fill(circleColor)
                .frame(width: 44, height: 44)

            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }

    private var circleColor: Color {
        switch item.status {
        case .success:
            return Color(red: 0.90, green: 0.97, blue: 0.93) // #E7F9EE
        case .failed:
            return Color(red: 1.0, green: 0.91, blue: 0.91) // #FDE8E8
        case .uploading:
            return Color(red: 0.95, green: 0.95, blue: 0.97) // #F1F1F7
        }
    }

    private var iconName: String {
        switch item.status {
        case .success: return "checkmark"
        case .failed: return "exclamationmark"
        case .uploading: return "receipt"
        }
    }

    private var iconColor: Color {
        switch item.status {
        case .success: return Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
        case .failed: return Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
        case .uploading: return Color.accentDarkPurple // #3D5AFE
        }
    }

    // MARK: - Status Text + Progress

    @ViewBuilder
    private var statusSection: some View {
        switch item.status {

        case .uploading:
            VStack(alignment: .leading, spacing: 4) {

                // Progress bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(red: 0.85, green: 0.85, blue: 0.85)) // grey track
                        .frame(height: 8)

                    Capsule()
                        .fill(Color.secondaryPurple) // progress
                        .frame(
                            width: max(0, min(1, item.progress)) * 180,
                            height: 8
                        )
                }

                Text("\(Int(item.progress * 100))%")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            }

        case .success:
            Text("Uploaded successfully!")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.20, green: 0.78, blue: 0.35)) // green

        case .failed:
            Text("Could not be uploaded!")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 1.0, green: 0.23, blue: 0.19)) // red
        }
    }

    // MARK: - Buttons (Retry + Delete)

    @ViewBuilder
    private var rightButtons: some View {
        HStack(spacing: 10) {

            // Retry only when failed
            if item.status == .failed, let retry = onRetry {
                Button(action: retry) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 213/255, green: 228/255, blue: 240/255)) // #E4E4E4
                            .frame(width: 28, height: 28)

                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 108/255, green: 178/255, blue: 231/255))
                    }
                }
            }

            // Delete always
            if let delete = onDelete {
                Button(action: delete) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.89, green: 0.89, blue: 0.89)) // #E4E4E4
                            .frame(width: 28, height: 28)

                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.44))
                    }
                }
            }
        }
    }
}

struct FileUploadList: View {
    @State var uploads: [UploadItem]

    init(uploads: [UploadItem] = []) {
        _uploads = State(initialValue: uploads)
    }

    var body: some View {
        VStack(spacing: 14) {
            ForEach(uploads) { item in
                FileUploadRow(
                    item: item,
                    onRetry: { retryUpload(item) },
                    onDelete: { delete(item) }
                )
            }
        }
        .padding(.horizontal)
    }

    private func retryUpload(_ item: UploadItem) {
        guard let idx = uploads.firstIndex(where: { $0.id == item.id }) else { return }
        uploads[idx].status = .uploading
        uploads[idx].progress = 0.0
    }

    private func delete(_ item: UploadItem) {
        uploads.removeAll { $0.id == item.id }
    }
}

// MARK: - Preview

struct FileUploadList_Previews: PreviewProvider {
    static var previews: some View {
        FileUploadList(uploads: [
            UploadItem(fileName: "ReciptName1.png", status: .uploading, progress: 0.7),
            UploadItem(fileName: "ReciptNameSuccessful.png", status: .success),
            UploadItem(fileName: "FailedUploadFile.pdf", status: .failed)
        ])
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
