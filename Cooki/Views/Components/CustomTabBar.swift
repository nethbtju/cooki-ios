//
//  CustomTabBar.swift
//  Cooki
//
//  Created by Neth Botheju on 14/9/2025.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @State private var isExpanded = false
    @State private var showPills = false
    var pillData: [(icon: String, text: String, action: () -> Void)]
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                // MARK: Pills (staggered animation)
                if isExpanded {
                    // MARK: Pills (staggered animation)
                    VStack(spacing: 10) {
                        ForEach(Array(pillData.enumerated()), id: \.offset) { index, pill in
                            PillButton(icon: pill.icon, text: pill.text, action: pill.action)
                                .opacity(showPills ? 1 : 0)
                                .offset(y: showPills ? 0 : 20)
                                .animation(
                                    .easeOut(duration: 0.3)
                                    .delay(0.05 * Double(index)),
                                    value: showPills
                                )
                        }
                    }
                }
            }
            .padding(.bottom, 40)
            
            ZStack {
                // Background capsule
                RoundedRectangle(cornerRadius: 52)
                    .fill(Color.accentViolet)
                    .frame(height: 70)
                    .padding(.horizontal, 20)
                    .shadow(radius: 4)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(10), Color.white.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 150)
                    .allowsHitTesting(false)
                    )
               
                HStack {
                    // Left two icons
                    TabBarItem(icon: "house.fill", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabBarItem(icon: "list.bullet", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    Spacer(minLength: 64) // 👈 space for center button
                    
                    // Right two icons
                    TabBarItem(icon: "calendar", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    TabBarItem(icon: "cart.fill", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                }
                .padding(.horizontal, 28)
                
                // Floating middle button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                        isExpanded.toggle()
                    }
                    
                    if !isExpanded {
                        showPills = false
                    } else {
                        // staggered pill animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation { showPills = true }
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isExpanded ? 45 : 0))
                        .scaleEffect(isExpanded ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isExpanded)
                        .frame(width: 64, height: 64)
                        .background(Color.secondaryPurple)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .offset(y: -32)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct TabBarItem: View {
    var icon: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
        }
    }
}

struct PillButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.secondaryPurple)
            .clipShape(Capsule())
            .shadow(radius: 3)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let pillData: [(icon: String, text: String, action: () -> Void)] = [
            ("scanner", "Scan receipt", {
                print("Scan tapped")
            }),
            ("cube.box", "Add new item", {
                print("Recipe tapped")
            }),
            ("magnifyingglass", "Add new recipe", {
                print("Recipe tapped")
            })
        ]
        CustomTabBar(selectedTab: .constant(0), pillData: pillData)
            .preferredColorScheme(.light)
            .previewDevice("iPhone 15 Pro")
    }
}
