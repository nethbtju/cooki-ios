//
//  ModalSheet.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct ModalSheet<Content: View>: View {
    var heightFraction: CGFloat = 0.75
    var cornerRadius: CGFloat = 27
    var content: () -> Content
    var profileImage: Image? = nil
    var profileSize: CGFloat = 100

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                VStack {
                    content()
                        .padding(.top) // leave space if profile is shown
                }
                .frame(height: UIScreen.main.bounds.height * heightFraction)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .background(Color.white)
                .clipShape(TopRoundedModal(radius: cornerRadius))
                .shadow(radius: 5)
            }

            if let profileImage = profileImage {
                ProfileIcon(image: profileImage, size: profileSize)
                    .offset(y: -(UIScreen.main.bounds.height * heightFraction) + profileSize / 2)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Shape for top corners
struct TopRoundedModal: Shape {
    var radius: CGFloat = 27
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
