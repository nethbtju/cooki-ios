//
//  PantryItemCard.swift
//  Cooki
//
//  Created by Neth Botheju on 19/9/2025.
//
// PantryItemCard.swift
import SwiftUI

struct PantryItemCard: View {
    let imageName: String
    let title: String
    let quantity: String
    var daysLeft: Int
    
    var status: (labelText: String, labelColor: Color, textColor: Color) {
        formatDaysLeft(daysLeft: daysLeft)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Image container
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 70)
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 70)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 20)
                
                // Title with fixed space for 2 lines
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(10 / 12)
                    .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading) // reserve space
                
                // Quantity
                Text("Qty: \(quantity)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .frame(width: 125, height: 170) // uniform size
            .background(Color.backgroundGrey.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.textGrey3.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Expiry badge (always aligned)
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

struct PantryItemCard_Previews: PreviewProvider {
    static var previews: some View {
        PantryItemCard(
            imageName: "StrawberryJam",
            title: "Cottee's Strawberry Jam",
            quantity: "375g",
            daysLeft: 0
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

func formatDaysLeft(daysLeft: Int) -> (labelText: String, labelColor: Color, textColor: Color) {
    if daysLeft == 0{
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
