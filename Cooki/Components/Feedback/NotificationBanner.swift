//
//  NotificationBanner.swift
//  Cooki
//

import SwiftUI

// MARK: - Notification Type
enum NotificationType {
    case info
    case success
    case error
    case decision(
        onYes: () -> Void,
        onNo: () -> Void
    )
    
    var backgroundColor: Color {
        switch self {
        case .success: return Color.green.opacity(0.85)
        case .error: return Color.red.opacity(0.85)
        case .info: return Color.accentPeach
        case .decision: return Color.blue.opacity(0.85)
        }
    }
    
    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .info: return "bell.fill"
        case .decision: return "questionmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success, .error, .decision: return .white
        case .info: return Color.accentBurntOrange
        }
    }
}

// MARK: - Notification Banner
struct NotificationBanner: View {
    @State private var isVisible = false
    @State private var expanded = false
    @State private var bellShake = false
    @State private var scale: CGFloat = 1.0
    
    @Binding var showBanner: Bool
    var text: String?
    var type: NotificationType = .info
    
    var body: some View {
        if let text = text, !text.isEmpty, showBanner {
            HStack(spacing: 8) {
                
                // Icon
                Image(systemName: type.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(type.iconColor)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(bellShake ? -10 : 0), anchor: .top)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.2)) { scale = 1.4 }
                        withAnimation(.easeInOut(duration: 0.15).repeatCount(3, autoreverses: true)) { bellShake = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            bellShake = false
                            withAnimation(.easeInOut(duration: 0.1)) { scale = 1.0 }
                        }
                    }
                
                if expanded {
                    Text(text)
                        .foregroundColor(.white)
                        .font(AppFonts.buttonFont())
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Decide what buttons to show
                    switch type {
                    case .decision(let onYes, let onNo):
                        HStack(spacing: 12) {
                            // No button (cross)
                            Button(action: {
                                onNo()
                                showBanner = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                            
                            // Yes button (tick)
                            Button(action: {
                                onYes()
                                showBanner = false
                            }) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                        }
                    default:
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showBanner = false
                            }
                        } label: {
                            CloseIconView(iconColor: type.iconColor, background: type.backgroundColor)
                        }
                    }
                }
            }
            .padding(8)
            .background(type.backgroundColor)
            .clipShape(Capsule())
            .shadow(radius: 4)
            .padding(.horizontal, 20)
            .frame(maxWidth: isVisible ? .infinity : 60, alignment: .leading)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isVisible)
            .onAppear {
                withAnimation { isVisible = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { bellShake.toggle() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { withAnimation { expanded = true } }
            }
        }
    }
}

// MARK: - Helper Views
struct CloseIconView: View {
    var iconColor: Color
    var background: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(background.opacity(0.8))
                .frame(width: 20, height: 20)
                .overlay(Circle().stroke(iconColor, lineWidth: 2))
            Image(systemName: "xmark")
                .foregroundColor(iconColor)
                .font(.system(size: 10, weight: .bold))
        }
        .padding(.trailing, 4)
    }
}

// MARK: - Preview
struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            NotificationBanner(showBanner: .constant(true), text: "4 items in pantry expiring soon!", type: .info)
            NotificationBanner(showBanner: .constant(true), text: "Successfully joined Test's Pantry!", type: .success)
            NotificationBanner(showBanner: .constant(true), text: "Failed to join pantry.", type: .error)
            NotificationBanner(
                showBanner: .constant(true),
                text: "Rohit wants to join your pantry.",
                type: .decision(
                    onYes: { print("Approved!") },
                    onNo: { print("Rejected!") }
                )
            )
        }
        .previewDevice("iPhone 15 Pro")
        .preferredColorScheme(.light)
        .padding(.top, 40)
    }
}
