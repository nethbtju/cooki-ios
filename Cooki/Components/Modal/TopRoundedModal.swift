//
//  TopRoundedModal.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

// Shape for top corners
struct TopRoundedModal: Shape {
    var radius: CGFloat?
    let defaultRadius: CGFloat = 27
    
    func path(in rect: CGRect) -> Path {
        let adjustedRect = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height + 100  // Extend beyond bottom
        )
        
        let path = UIBezierPath(
            roundedRect: adjustedRect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius ?? defaultRadius, height: radius ?? defaultRadius)
        )
        return Path(path.cgPath)
    }
}
