//
//  ProfileIcon.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct ProfileIcon: View {
    let image: Image
    var size: CGFloat = 100
    var borderColor: Color = .white
    var borderWidth: CGFloat = 4
    var shadowRadius: CGFloat = 5

    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(borderColor, lineWidth: borderWidth))
    }
}
