//
//  PantryItemCard.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//

import SwiftUI

struct PantryItemCard: View {
    let pantryItem: PantryItem
    var deleteOpt: Bool = false
    
    var status: (labelText: String, labelColor: Color, textColor: Color) {
        formatDaysLeft(daysLeft: pantryItem.daysLeft)
    }
    
    var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 20
        let spacing: CGFloat = 10
        let columns: CGFloat = 3
        
        return (screenWidth - (horizontalPadding * 2) - (spacing * (columns - 1))) / columns
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Image container
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 70)
                    
                    pantryItem.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 70)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 20)
                
                
                // Title
                Text(pantryItem.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(10 / 12)
                    .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                
                // Quantity
                Text("Qty: \(pantryItem.quantity)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .frame(width: cardWidth, height: cardWidth * 1.35)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
            )
            
            // Expiry badge
            Text(status.labelText)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(status.textColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 1.5)
                .background(status.labelColor)
                .clipShape(Capsule())
                .offset(x: -10, y: 6)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Helper
func formatDaysLeft(daysLeft: Int) -> (labelText: String, labelColor: Color, textColor: Color) {
    if daysLeft == 0 {
        return (labelText: "Expired ⚠️", labelColor: Color.textRed, textColor: Color.white)
    }
    if daysLeft < 2 {
        return (labelText: "1 day left", labelColor: Color.accentRed, textColor: Color.textRed)
    } else if daysLeft < 4 {
        return (labelText: "\(daysLeft) days left", labelColor: Color.accentYellow, textColor: Color.textYellow)
    } else {
        return (labelText: "\(daysLeft) days left", labelColor: Color.accentGreen, textColor: Color.textGreen)
    }
}

// MARK: - Preview
struct PantryItemCard_Previews: PreviewProvider {
    static var previews: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(PantryItem.mockPantrytems) { item in
                    PantryItemCard(
                        pantryItem: item
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .previewLayout(.sizeThatFits)
    }
}
