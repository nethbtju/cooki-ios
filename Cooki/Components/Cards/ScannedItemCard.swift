//
//  ScannedItemCard.swift
//  Cooki
//
//  Created by Neth Botheju on 16/11/2025.
//
import SwiftUI

struct ScannedItemCard: View {
    let item: PantryItem
    let onRemove: () -> Void
    
    var cardWidth: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: cardWidth * 0.45)
                    
                    item.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: cardWidth * 0.55)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 20)
                
                Text(item.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(10 / 12)
                    .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                
                // Quantity
                Text("Qty: \(item.quantity)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(width: cardWidth, height: cardWidth * 1.35)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
            )
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.accent)
                    .frame(width: 20, height: 20)
                    .background(Color.background.opacity(0.9))
                    .clipShape(Circle())
            }
            .offset(x: -6, y: 6)
        }
    }
}

// MARK: - Preview
struct ScannedItemCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                let columns = [
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4)
                ]
                var items = PantryItem.mockPantrytems
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(items) { item in
                        ScannedItemCard(item: item) {
                            withAnimation {
                                items.removeAll { $0.id == item.id }
                            }
                        }
                    }
                }
            }
        }
    }
}
