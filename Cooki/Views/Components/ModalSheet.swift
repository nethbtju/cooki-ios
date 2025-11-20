//
//  ModalSheet.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct ModalSheet<Content: View>: View {
    var heightFraction: CGFloat = 0.75
    var content: () -> Content

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                VStack() {
                    content()
                }
                .frame(height: UIScreen.main.bounds.height * heightFraction)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .background(Color.white)
                .clipShape(TopRoundedModal())
                .shadow(radius: 5)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .padding(0)
    }
}

struct ModalSheet_Previews: PreviewProvider {
    static var previews: some View {
        ModalSheet(
            heightFraction: 0.7,
            content: {
                VStack(spacing: 20) {
                    Text("Hello Cooki 👋")
                        .font(.title)
                        .foregroundColor(.black)
                    Text("This is a preview of the modal sheet.")
                        .foregroundColor(.gray)
                    Button("Test Button") {
                        print("Tapped in preview")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
            }
        )
        .previewDevice("iPhone 15 Pro")
    }
}
