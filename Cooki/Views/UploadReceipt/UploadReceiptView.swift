//
//  UploadReceiptView.swift
//  Cooki
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Main Upload Receipt View
public struct UploadReceiptView: View {
    var onNavigateToPantry: () -> Void = {}
    
    public var body: some View {
        MainLayout(
            header: { UploadReceiptHeader() },
            content: { UploadReceiptContent(onNavigateToPantry: onNavigateToPantry) }
        )
    }
}

// MARK: - Preview
struct UploadReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        UploadReceiptView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

// MARK: - Upload Content
public struct UploadReceiptContent: View {
    @State private var uploads: [Upload] = []
    @State private var showingFilePicker = false
    @State private var navigateToSuccessPage = false
    @State private var scannedItems: [Item] = []
    @State private var isScanning = false
    
    var onNavigateToPantry: () -> Void = {}

    private let receiptService = ReceiptProcessingService()

    public var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    OptionCardButton(
                        icon: "receipt",
                        title: "Click here to add your receipt files",
                        subtitle: "Supported files: PNG, JPG, JPEG, PDF (10mb each)",
                        primaryColor: Color.accentDarkPurple,
                        secondaryColor: Color.accentViolet
                    ) {
                        showingFilePicker = true
                    }
                    .frame(height: 200)
                }
                .padding(.top, 42)
                
                Spacer().frame(height: 32)
                
                if uploads.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.up.circle")
                            .font(.system(size: 48))
                            .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.70))
                        Text("No receipts uploaded yet")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                        Text("Tap the button above to upload your receipts")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.70))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 60)
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        UploadCardList(uploads: $uploads, onRetryFile: retryUpload)
                    }
                    
                    PrimaryButton(
                        title: isScanning ? "Scanning..." : "Scan these receipts",
                        action: {
                            scanReceipts()
                        }
                    )
                    .disabled(uploads.isEmpty || isScanning)
                    .opacity(isScanning ? 0.6 : 1.0)
                    .navigationDestination(isPresented: $navigateToSuccessPage) {
                        ReceiptSuccessView(
                            items: scannedItems,
                            onAddItems: {
                                onNavigateToPantry()
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.png, .jpeg, .pdf],
            allowsMultipleSelection: true
        ) { result in
            handleFileSelection(result)
        }
    }

    // MARK: - File Selection
    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            for url in urls {
                let newItem = Upload(
                    fileName: url.lastPathComponent,
                    fileURL: url,
                    status: .pending
                )
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    uploads.insert(newItem, at: 0)
                }
            }
        case .failure(let error):
            print("File selection error: \(error.localizedDescription)")
        }
    }

    // MARK: - Retry Upload
    private func retryUpload(_ itemId: UUID) {
        guard let index = uploads.firstIndex(where: { $0.id == itemId }) else { return }
        uploads[index].status = .uploading
        uploads[index].progress = 0
        scanReceipts()
    }

    // MARK: - Scan receipts with simulated progress
    private func scanReceipts() {
        isScanning = true
        
        for i in uploads.indices {
            uploads[i].status = .uploading
            uploads[i].progress = 0
        }
        
        guard uploads.first != nil else {
            isScanning = false
            return
        }
        
        let totalSimulatedTime: Double = 2.0
        let targetProgress: Double = 0.85
        var elapsedTime: Double = 0
        let interval: Double = 0.05
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            elapsedTime += interval
            let simulatedProgress = min(targetProgress, (elapsedTime / totalSimulatedTime) * targetProgress)
            for i in uploads.indices {
                uploads[i].progress = simulatedProgress
            }
            
            if elapsedTime >= totalSimulatedTime {
                timer.invalidate()
                
                Task {
                    do {
                        var allItems: [Item] = []
                        for upload in uploads {
                            let data = try await fetchReceiptData(for: upload.fileURL)
                            await allItems.append(contentsOf: try ReceiptToItemConverter.convert(data))
                        }
                        scannedItems = allItems
                        
                        for i in uploads.indices {
                            uploads[i].progress = 1.0
                            uploads[i].status = .success
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            navigateToSuccessPage = true
                            isScanning = false
                        }
                    } catch {
                        print("Unexpected failure: \(error.localizedDescription)")
                        isScanning = false
                        
                        for i in uploads.indices {
                            uploads[i].status = .failed
                        }
                    }
                }
            }
        }
    }
}

// MARK: - API Helper
extension UploadReceiptContent {
    func fetchReceiptData(for fileURL: URL?) async throws -> ReceiptData {
        guard let fileURL else { throw NSError(domain: "MissingFile", code: 0) }
        
        if AppConfig.useMockService {
            return try await fetchMockReceiptData()
        } else {
            return try await receiptService.processReceipt(fileURL: fileURL)
        }
    }

    private func fetchMockReceiptData() async throws -> ReceiptData {
        try await Task.sleep(for: .seconds(1))
        var fakeItems: [ReceiptItem] = []
        for i in 1...20 {
            fakeItems.append(
                ReceiptItem(
                    name: "Item \(i)",
                    qty: Int.random(in: 1...5),
                    weight: ReceiptWeight(value: Double.random(in: 0.1...2.0), unit: .kg),
                    price: Double.random(in: 1.0...50.0)
                )
            )
        }
        return ReceiptData(
            storeName: "Coles",
            date: "08/09/2025",
            totalAmount: fakeItems.reduce(0.0) { $0 + ($1.price ?? 0.0) * Double($1.qty) },
            items: fakeItems
        )
    }
}
