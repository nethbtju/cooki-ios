//
//  UploadFileView.swift
//  Cooki
//
//  Created by Neth Botheju on 19/10/2025.
//
import SwiftUI

struct UploadFileView: View {
    
    @State var uploads: [UploadItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Title at top with proper spacing
            Text("Add to Pantry")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.bottom, 28)
            
            // Upload button
            VStack(spacing: 20) {
                AddItemOptionButton(
                    iconName: "receipt",
                    title: "Click here to add your receipt files",
                    subtitle: "Supported files: PNG, JPG, JPEG, PDF (10mb each)",
                    primaryColor: Color.accentDarkPurple,
                    secondaryColor: Color.accentViolet
                ) {
                    print("Camera tapped!")
                }
                .frame(height: 200)
            }
            
            // Spacing before upload list
            Spacer().frame(height: 32)
            
            // Scrollable upload list or empty state
            ScrollView(.vertical, showsIndicators: true) {
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
                    FileUploadList(uploads: uploads)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct UploadFileView_Previews: PreviewProvider {
    static var previews: some View {
        UploadFileView(uploads: [
            UploadItem(fileName: "ReciptName1.png", status: .uploading, progress: 0.7),
            UploadItem(fileName: "ReciptNameSuccessful.png", status: .success),
            UploadItem(fileName: "FailedUploadFile.pdf", status: .failed)
        ])
        .previewDevice("iPhone 15 Pro")
        .preferredColorScheme(.light)
    }
}
