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
                VStack(spacing: 12) {
                    Spacer()
                        .frame(height: 40)
                    
                    Text("Receipt successfully read!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Cooki will add these items to your pantry")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                
                // Scalloped edge
                HStack(spacing: 0) {
                    ForEach(0..<18, id: \.self) { _ in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 2)
                            .offset(y: 10)
                    }
                }
                .frame(height: 20)
                .background(Color.white)
            }
            .background(Color.white)
            .clipShape(TopRoundedModal())
            .padding(.top, 50)
            
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
            .offset(y: 10)
        }
    }
}

// MARK: - Preview
struct ReceiptContentCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                ReceiptContentCard(items: PantryItem.mockPantrytems)
            }
        }
    }
}
