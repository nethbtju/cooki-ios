//
//  NotificationBar.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//
import SwiftUI

struct NotificationBanner: View {
    @State private var isVisible = false       // controls showing/hiding
    @State private var expanded = false        // controls expansion
    @State private var bellShake = false       // controls bell shake
    @State private var scale: CGFloat = 1.0    // controls the scale factor
    @Binding var showBanner: Bool              // controls visibility from parent
    var text: String?
    
    var body: some View {
        if let text = text, !text.isEmpty, showBanner {
            HStack() {
                // Bell icon inside circle
                ZStack {
                    Image(systemName: "bell")
                        .font(.system(size: 20))
                        .foregroundColor(Color.accentBurntOrange)
                        .rotationEffect(.degrees(bellShake ? -10 : 0), anchor: .top)
                        .scaleEffect(scale)
                        .onAppear {
                            // Start shake
                            withAnimation(.easeOut(duration: 0.2)) {
                                scale = 1.4
                            }
                            withAnimation(
                                .easeInOut(duration: 0.15)
                                .repeatCount(3, autoreverses: true)
                            ) {
                                bellShake = true
                            }
                            
                            
                            // Reset + expand pop
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                bellShake = false
                                
                                withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                                    scale = 1.0
                                }
                            }
                        }
                }
                
                if expanded {
                    Text(text)
                        .foregroundColor(.white)
                        .font(AppFonts.buttonFont())
                        .lineLimit(1)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showBanner = false
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.accentLightOrange.opacity(0.8))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle().stroke(Color.accentBurntOrange, lineWidth: 2)
                                )
                            
                            Image(systemName: "xmark")
                                .foregroundColor(Color.accentBurntOrange)
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.trailing, 4)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(8)
            .background(Color.accentPeach)
            .clipShape(Capsule())
            .shadow(radius: 4)
            .padding(.horizontal, 20)
            .frame(maxWidth: isVisible ? .infinity : 60, alignment: .leading)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isVisible)
            .onAppear {
                // Step 1: show circle
                withAnimation {
                    isVisible = true
                }
                // Step 2: shake the bell after slight delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    bellShake.toggle()
                }
                // Step 3: expand banner after shake
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation {
                        expanded = true
                    }
                }
            }
            .opacity(isVisible ? 1 : 0)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(showBanner: .constant(true), text: "4 items in pantry expiring soon!")
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
            .padding(.top, 40)
    }
}
