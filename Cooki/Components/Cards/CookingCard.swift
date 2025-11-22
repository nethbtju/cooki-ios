//
//  CookingCard.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//
import SwiftUI

struct CookingCard: View {
    var image: Image
    var title: String
    var date: String
    var serving: Int
    var action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center) {
                image.resizable()
                    .scaledToFill()
                    .frame(height: 124)
                    .clipped()
                
                VStack(alignment: .center) {
                    Text(title)
                        .font(AppFonts.cardTitle())
                        .foregroundColor(.primary)
                    
                    HStack(alignment: .center) {
                        Text(date)
                            .font(AppFonts.smallBody())
                            .foregroundColor(.textGrey2)
                            .lineLimit(3)
                        
                        Image(systemName: "circle.fill")
                            .foregroundColor(.textGrey2)
                            .font(.system(size: 4))
                        
                        Text("\(serving) servings")
                            .font(AppFonts.smallBody())
                            .foregroundColor(.textGrey2)
                            .lineLimit(3)
                    }
                    
                    Spacer().frame(maxHeight: 10)
                    
                    Button(action: action) {
                        Text("Start Cooking")
                            .font(AppFonts.buttonFontSmall())
                            .fontWeight(.bold)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 4)
                            .background(.white)
                            .foregroundColor(.accentLightOrange)
                            .clipShape(Capsule())
                    }
                    .shadow(radius: 2)
                }
                .padding(.bottom, 14)
                .padding(.top, 6)
            }
            .background(Color.cardBackground)
        }
        .cornerRadius(12)
        .frame(minWidth: 180, maxWidth: 180)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 0.7)
        )
    }
}

struct CookingCard_Previews: PreviewProvider {
    static var previews: some View {
        CookingCard(
            image: Image("FillerFoodImage"),
            title: "Delicious Pasta",
            date: "Sat",
            serving: 4,
            action: ({ print("Tapped!") })
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
