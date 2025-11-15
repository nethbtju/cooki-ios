//
//  UploadFileView.swift
//  Cooki
//
//  Created by Neth Botheju on 19/10/2025.
//
import SwiftUI

struct UploadFileView: View {
    var body: some View {
        VStack {
            Text("Add to pantry")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            VStack(spacing: 20) { // consistent spacing between buttons
                AddItemOptionButton(
                    iconName: "arrow.up.doc",
                    title: "Click here to add your receipt files",
                    subtitle: "Supported files: PNG, JPG, JPEG, PDF (10mb each)",
                    primaryColor: Color.accentDarkPurple,
                    secondaryColor: Color.accentViolet
                ) {
                    print("Camera tapped!")
                }
                Spacer()
            }
            .padding(.horizontal)
            Spacer().frame(height: 60)
        }
    }
}

struct UploadFileView_Previews: PreviewProvider {
    static var previews: some View {
        UploadFileView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

