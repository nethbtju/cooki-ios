//
//  SelectReceiptMethod.swift
//  Cooki
//
//  Created by Neth Botheju on 6/10/2025.
//
import SwiftUI

struct AddPantryItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToUpload = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Content
                VStack(spacing: 20) {
                    AddItemOptionButton(
                        iconName: "camera.fill",
                        title: "Use Camera",
                        subtitle: "Take a photo of your receipt",
                        primaryColor: Color.accentBurntOrange,
                        secondaryColor: Color.accentPeach
                    ) {
                        print("mao")
                    }
                    
                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)
                        .padding(.horizontal, 24)
                    
                    AddItemOptionButton(
                        iconName: "photo.on.rectangle",
                        title: "Upload eReceipt",
                        subtitle: "Choose from your files",
                        primaryColor: Color.accentViolet,
                        secondaryColor: Color.secondaryPurple
                    ) {
                        navigateToUpload = true
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Add to Pantry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToUpload) {
                UploadFileView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.textGreyDark)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
    }
}

struct AddPantryItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddPantryItemView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
