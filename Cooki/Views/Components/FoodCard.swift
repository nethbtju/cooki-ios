//
//  FoodCard.swift
//  Cooki
//
//  Created by Rohit Valanki on 19/9/2025.
//


//
//  FoodCard.swift
//  Cooki
//
//  Created by Rohit Valanki on 17/9/2025.
//


import SwiftUI

struct FoodCard: View {
    let imageName: String
    let title: String
    let quantity: Int
    let daysToExpiry: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Reserve fixed space for the image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)   // fixed height container
                    .cornerRadius(8)
                    .padding(.top, 20)  // pushes it down so bubble doesn’t overlap
                
                // Item name
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Quantity
                Text("Qty: \(quantity)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.foodCard)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // 👈 faint shadow
            
            // Expiry bubble (badge)
            Text(daysToExpiry > 0 ? "\(daysToExpiry) days left" : "Expired ⚠️")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 1.5)
                .background(
                    (daysToExpiry > 3 ? Color.green : (daysToExpiry > 0 ? Color.orange : Color.red))
                        .opacity(0.8)
                )
                .clipShape(Capsule())
                .offset(x: -10, y: 6)
        }
        .frame(height: 140) // ensures all cards align neatly
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCard(
            imageName: "CookieIcon",
            title: "Apples",
            quantity: 6,
            daysToExpiry: 2
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
