//
//  ProfileIcon.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI
import PhotosUI

struct ProfileIcon: View {
    let image: Image
    var size: CGFloat = 100
    var editable: Bool = false
    var borderWidth: CGFloat = 4
    var shadowRadius: CGFloat = 5

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // MARK: - Profile image
            Group {
                if let uiImage = selectedUIImage {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    image
                        .resizable()
                }
            }
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())

            // MARK: - Camera button
            if editable {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: size * 0.12))
                        .foregroundColor(.white)
                        .frame(
                            width: size * 0.24,
                            height: size * 0.24
                        )
                        .background(Color.accentPeach)
                        .clipShape(Circle())
                }
                .offset(x: size * 0.01, y: size * 0.01)
            }
        }
        .frame(width: size, height: size)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProfileIcon(image: Image("ProfilePic"), size: 40)
    
    ProfileIcon(image: Image("ProfilePic"), size: 150, editable: true)
}

