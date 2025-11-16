//
//  ReceiptContentCard.swift
//  Cooki
//
//  Created by Neth Botheju on 15/11/2025.
//
import SwiftUI

// MARK: - Receipt Content Card
struct ReceiptContentCard: View {
    @State var items: [PantryItem]
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            // White card
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
                            ScannedItemCard(item: item) {
                                withAnimation {
                                    items.removeAll { $0.id == item.id }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                
                
                CtaButton(ctaText: "Add Items", action: {print("mao")})
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                
                // Scalloped edge
                GeometryReader { geometry in
                    let availableWidth = geometry.size.width
                    let maxScallopSize: CGFloat = 20
                    let gapRatio: CGFloat = 1/6
                    
                    let estimatedScallops = Int(availableWidth / (maxScallopSize * (1 + gapRatio)))
                    let actualScallopSize = min(maxScallopSize, availableWidth / (CGFloat(estimatedScallops) * (1 + gapRatio)))
                    let actualGap = actualScallopSize * gapRatio
                    
                    HStack(spacing: actualGap) {
                        ForEach(0..<estimatedScallops, id: \.self) { _ in
                            Circle()
                                .fill(Color.blue)
                                .frame(width: actualScallopSize, height: actualScallopSize)
                                .offset(y: actualScallopSize / 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .background(Color.white)
                }
                .frame(height: 20)
            }
            .background(Color.white)
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

// MARK: - Preview
struct ReceiptContentCard_Previews: PreviewProvider {
    static var previews: some View {
            VStack {
                ReceiptContentCard(items: PantryItem.mockPantrytems)
            }
            .background(Color.blue)
    }
}
