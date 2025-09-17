//
//  SuggestMealCard.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//
import SwiftUI

struct SuggestMealCard: View {
    var imageName: String
    var title: String
    var prepTime: (hour: Int, minute: Int)
    var serving: Int
    var action: () -> Void
    var aiSuggestionText: String

    var body: some View {
        HStack(spacing: 6) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 120)
                    .cornerRadius(8)
                    .padding(16)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(AppFonts.heading2())
                    .lineLimit(1)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                HStack(alignment: .center) {
                    Image(systemName: "clock")
                        .foregroundColor(.textGrey3)
                        .font(.system(size: 12))
                    
                    Text("\(String(prepTime.hour)) hours \(String(prepTime.minute)) mins")
                        .font(AppFonts.smallBody())
                        .foregroundColor(.textGrey3)
                        .lineLimit(3)
                    
                    Image(systemName: "circle.fill")
                        .foregroundColor(.textGrey3)
                        .font(.system(size: 4))
                    
                    Text("\(serving) servings")
                        .font(AppFonts.smallBody())
                        .foregroundColor(.textGrey3)
                        .lineLimit(3)
                }
                
                VStack {
                    Text(aiSuggestionText)
                        .font(AppFonts.smallBody2())
                        .lineLimit(1)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                }
                .background(Color.accentPeach.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textGrey3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentPeach, lineWidth: 1)
                )
                
                Button(action: action) {
                    HStack {
                        // Left-aligned content
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 8, weight: .bold))
                            .padding(3)
                            .background(
                                Circle()
                                    .fill(Color.accentBurntOrange)
                            )
                        
                        Text("Add to meal plan")
                            .font(AppFonts.smallBody2())
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentLightOrange)
                        
                        Spacer()
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.textGrey.opacity(0.5), lineWidth: 1)
                )
                .padding(.top, 6)
            }
            .padding(.trailing, 16)
        }
        .background(Color.backgroundGrey.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

struct SuggestMealCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestMealCard(
            imageName: "FillerFoodImage2",
            title: "Delicious Pasta",
            prepTime: (hour: 2, minute: 50),
            serving: 4,
            action: ({ print("Tapped!") }),
            aiSuggestionText: "Meet your protein goals with this meal"
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
