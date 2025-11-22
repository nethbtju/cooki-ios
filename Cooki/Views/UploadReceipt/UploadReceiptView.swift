//
//  UploadReceiptView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/11/2025.
//
import SwiftUI

public struct UploadReceiptView: View {
    public var body: some View {
        MainLayout(header: { UploadReceiptHeader() }, content: { UploadReceiptContent() })
    }
}

struct UploadReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        UploadReceiptView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

public struct UploadReceiptContent: View {
    @State var uploads: [Upload] = []
    
    @State private var navigateToSuccessPage = false
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
                        print("Camera tapped!")
                    }
                    .frame(height: 200)
                }
                .padding(.top, 42)
                
                // Spacing before upload list
                Spacer().frame(height: 32)
                
                // Scrollable upload list or empty state
                
//                if uploads.isEmpty {
//                    VStack(spacing: 12) {
//                        Image(systemName: "arrow.up.circle")
//                            .font(.system(size: 48))
//                            .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.70))
//                        
//                        Text("No receipts uploaded yet")
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
//                        
//                        Text("Tap the button above to upload your receipts")
//                            .font(.system(size: 15))
//                            .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.70))
//                            .multilineTextAlignment(.center)
//                    }
//                    .padding(.vertical, 60)
//                    .frame(maxWidth: .infinity)
//                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        UploadCardList(uploads: uploads)
                    }
                    
                    PrimaryButton(title: "Scan these receipts", action: { navigateToSuccessPage = true
                    })
                    .navigationDestination(isPresented: $navigateToSuccessPage) {
                        ReceiptSuccessView()
                            .navigationBarBackButtonHidden(true)
                    }
//                }
                
                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
    }
}

public struct UploadReceiptHeader: View {
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        // Navigation bar with back button
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                // Info action
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}
