//
//  CardLayout.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

// MARK: - Card Layout Utilities
struct CardLayout {
    /// Calculate card width for grid layouts
    static func gridCardWidth(columns: Int = 3, horizontalPadding: CGFloat = 20, spacing: CGFloat = 10) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalPadding = (horizontalPadding * 2) + (spacing * CGFloat(columns - 1))
        return (screenWidth - totalPadding) / CGFloat(columns)
    }
    
    /// Standard aspect ratios for cards
    enum AspectRatio {
        case square
        case portrait
        case landscape
        
        var value: CGFloat {
            switch self {
            case .square: return 1.0
            case .portrait: return 1.35
            case .landscape: return 0.75
            }
        }
    }
}
