//
//  ReceiptSuccessView.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

struct ReceiptSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ReceiptContentHeader()
            
            ReceiptContentCard(items: MockData.pantryItems)
        }
        .background {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .offset(x: -50, y: -50)
                .ignoresSafeArea()
        }
        .background(Color.secondaryPurple)
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
struct ReceiptSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReceiptSuccessView()
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
        }
    }
}


// MARK: - Receipt Content Card
struct ReceiptContentCard: View {
    @State var items: [Item]
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            // White card with scalloped bottom
            VStack(spacing: 0) {
                // Header with text
                VStack(spacing: 6) {
                    Spacer()
                        .frame(height: 40)
                    
                    Text("Receipt successfully read!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.text)
                    
                    Text("Cooki will add these items to your pantry")
                        .font(.system(size: 12))
                        .foregroundColor(.textGreyDark)
                }
                .padding(.bottom, 24)
                
                // Items grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(items) { item in
                            let deleteAction = {
                                withAnimation {
                                    items.removeAll { $0.id == item.id }
                                }
                            }

                            ItemCard.scannedItem(item, onDelete: deleteAction)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                
                PrimaryButton(title: "Add Items", action: {print("mao")})
                    .padding(.horizontal, 15)
                    .padding(.bottom, 28)
            }
            .background(Color.white)
            .mask {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white)
                        
                        ScallopedEdgeMask()
                            .fill(Color.white)
                            .frame(height: 20)
                            .rotationEffect(.degrees(180))
                    }
                }
            }
            .clipShape(TopRoundedModal())
            .padding(.horizontal, 20)
            .padding(.top, 35)
            
            // Floating white circle with checkmark
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 85, height: 85)
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.green)
            }
            .offset(y: -3)
        }
    }
}

// MARK: - Header
public struct ReceiptContentHeader: View {
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        // Navigation bar with back button
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


// MARK: - Scalloped Edge Mask
struct ScallopedEdgeMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let circleRadius: CGFloat = 11
        let circleDiameter = circleRadius * 2
        let spacing: CGFloat = 8
        
        let totalWidth = circleDiameter + spacing
        let circleCount = Int(rect.width / totalWidth)
        
        // Calculate the total width used by circles and spacing
        let totalUsedWidth = CGFloat(circleCount) * circleDiameter + CGFloat(circleCount - 1) * spacing
        // Calculate equal margins on both sides
        let sideMargin = (rect.width - totalUsedWidth) / 2
        
        // Start from top left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Draw to the first margin
        path.addLine(to: CGPoint(x: sideMargin, y: 0))
        
        for i in 0..<circleCount {
            let centerX = sideMargin + CGFloat(i) * totalWidth + circleRadius
            
            // Draw the circle cutout (going upward into the card)
            path.addArc(
                center: CGPoint(x: centerX, y: 0),
                radius: circleRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: true
            )
            
            // Draw spacing between circles (except after the last one)
            if i < circleCount - 1 {
                path.addLine(to: CGPoint(x: centerX + circleRadius + spacing, y: 0))
            }
        }
        
        // Complete the path
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
