//
//  CustomTabBar.swift
//  Cooki
//
//  Created by Neth Botheju on 14/9/2025.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isExpanded: Bool
    @State private var showPills = false
    var pillData: [(icon: String, text: String, action: () -> Void)]
    
    var body: some View {
        VStack{
            VStack(spacing: 0) {
                // MARK: Tab Bar
                ZStack {
                    // Background capsule with gradient
                    RoundedRectangle(cornerRadius: 52)
                        .fill(Color.accentViolet)
                        .frame(height: 60)
                        .padding(.horizontal, 24)
                        .shadow(radius: 4)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0)]),
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
                        
                        Spacer(minLength: 64)
                        
                        // Right two icons
                        TabBarItem(icon: "calendar", isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }
                        TabBarItem(icon: "cart.fill", isSelected: selectedTab == 3) {
                            selectedTab = 3
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    VStack{
                        // MARK: Pills (staggered animation) - positioned above the tab bar
                        if isExpanded {
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
                            .padding(.bottom, 40)
                        }
                        
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    .offset(y: -32)
                }
            }
            .onChange(of: isExpanded) { newValue in
                if !newValue {
                    showPills = false
                }
            }
            .padding(.bottom, 16)
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
        .buttonStyle(PillButtonStyle())
    }
}

struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Usage Example
// Use this in your main views like this:
struct ContentViewExample: View {
    @State private var selectedTab = 0
    @State private var isExpanded = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Your scrollable content
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<20) { i in
                        Text("Item \(i)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .padding(.bottom, 100) // Add padding so content doesn't hide behind tab bar
            }
            // Floating tab bar
            CustomTabBar(
                selectedTab: $selectedTab,
                isExpanded: $isExpanded,
                pillData: [
                    ("scanner", "Scan receipt", { print("Scan tapped") }),
                    ("cube.box", "Add new item", { print("Add tapped") }),
                    ("magnifyingglass", "Add new recipe", { print("Recipe tapped") })
                ]
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewExample()
            .preferredColorScheme(.light)
            .previewDevice("iPhone 15 Pro")
    }
}
