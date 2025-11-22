//
//  CardConfiguration.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

// MARK: - Card Configuration
/// Centralized configuration for card appearance
struct CardConfiguration {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowOpacity: Double
    let borderColor: Color?
    let borderWidth: CGFloat
    let padding: EdgeInsets
    
    init(
        backgroundColor: Color = .cardBackground,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        borderColor: Color? = Color.gray.opacity(0.1),
        borderWidth: CGFloat = 0.5,
        padding: EdgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.padding = padding
    }
    
    // MARK: - Preset Configurations
    static let standard = CardConfiguration()
    
    static let elevated = CardConfiguration(
        shadowRadius: 8,
        shadowOpacity: 0.15
    )
    
    static let compact = CardConfiguration(
        padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    )
    
    static let minimal = CardConfiguration(
        shadowRadius: 2,
        shadowOpacity: 0.05,
        borderWidth: 0
    )
}

// MARK: - Card Container Modifier
/// Reusable modifier that applies card styling to any view
struct CardStyleModifier: ViewModifier {
    let configuration: CardConfiguration
    
    func body(content: Content) -> some View {
        content
            .background(configuration.backgroundColor)
            .cornerRadius(configuration.cornerRadius)
            .shadow(
                color: Color.black.opacity(configuration.shadowOpacity),
                radius: configuration.shadowRadius,
                x: 0,
                y: 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(
                        configuration.borderColor ?? .clear,
                        lineWidth: configuration.borderWidth
                    )
            )
    }
}

extension View {
    /// Applies card styling to a view
    func cardStyle(_ configuration: CardConfiguration = .standard) -> some View {
        self.modifier(CardStyleModifier(configuration: configuration))
    }
}

// MARK: - Status Badge Configuration
struct StatusBadgeConfiguration {
    let text: String
    let backgroundColor: Color
    let textColor: Color
    
    init(text: String, backgroundColor: Color, textColor: Color) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    // MARK: - Status Badge Factory
    static func expiryStatus(daysLeft: Int) -> StatusBadgeConfiguration {
        if daysLeft == 0 {
            return StatusBadgeConfiguration(
                text: "Expired ⚠️",
                backgroundColor: .textRed,
                textColor: .white
            )
        } else if daysLeft < 2 {
            return StatusBadgeConfiguration(
                text: "1 day left",
                backgroundColor: .accentRed,
                textColor: .textRed
            )
        } else if daysLeft < 4 {
            return StatusBadgeConfiguration(
                text: "\(daysLeft) days left",
                backgroundColor: .accentYellow,
                textColor: .textYellow
            )
        } else {
            return StatusBadgeConfiguration(
                text: "\(daysLeft) days left",
                backgroundColor: .accentGreen,
                textColor: .textGreen
            )
        }
    }
    
    static func uploadStatus(_ status: UploadStatus) -> (icon: String, backgroundColor: Color, iconColor: Color) {
        switch status {
        case .pending:
            return (
                icon: "clock",
                backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.97),
                iconColor: Color(red: 0.54, green: 0.54, blue: 0.56)
            )
        case .uploading:
            return (
                icon: "arrow.up.circle",
                backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.97),
                iconColor: Color.secondaryPurple
            )
        case .processing:
            return (
                icon: "gearshape.2",
                backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.97),
                iconColor: Color.secondaryPurple
            )
        case .success:
            return (
                icon: "checkmark",
                backgroundColor: Color(red: 0.90, green: 0.97, blue: 0.93),
                iconColor: Color(red: 0.20, green: 0.78, blue: 0.35)
            )
        case .failed:
            return (
                icon: "exclamationmark",
                backgroundColor: Color(red: 1.0, green: 0.91, blue: 0.91),
                iconColor: Color(red: 1.0, green: 0.23, blue: 0.19)
            )
        case .cancelled:
            return (
                icon: "xmark.circle",
                backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95),
                iconColor: Color(red: 0.54, green: 0.54, blue: 0.56)
            )
        }
    }
}

// MARK: - Status Badge View
struct StatusBadge: View {
    let configuration: StatusBadgeConfiguration
    
    var body: some View {
        Text(configuration.text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(configuration.textColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 1.5)
            .background(configuration.backgroundColor)
            .clipShape(Capsule())
    }
}
