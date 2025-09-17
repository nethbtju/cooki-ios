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
                    .foregroundStyle(Color.textBlack)
                HStack(spacing: 2) {
                    Image(systemName: "clock")
                        .foregroundStyle(Color.textGrey3)
                        .font(.system(size: 12))
                    
                    Text(formatPrepTime(prepTime: prepTime))
                        .font(AppFonts.smallBody())
                        .foregroundStyle(Color.textGrey3)
                    
                    Image(systemName: "circle.fill")
                        .foregroundStyle(Color.textGrey3)
                        .font(.system(size: 4))
                        .padding(.horizontal, 4)
                    
                    Text("\(serving) servings")
                        .font(AppFonts.smallBody())
                        .foregroundStyle(Color.textGrey3)
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
                            .foregroundStyle(Color.white)
                            .font(.system(size: 8, weight: .bold))
                            .padding(3)
                            .background(
                                Circle()
                                    .fill(Color.accentBurntOrange)
                            )
                        
                        Text("Add to meal plan")
                            .font(AppFonts.smallBody())
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentLightOrange)
                        
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
    
    func formatPrepTime(prepTime: (hour: Int, minute: Int)) -> String {
        var hourText = ""
        var minuteText = ""

        if prepTime.hour == 1 {
            hourText = "hour"
        } else if prepTime.hour > 1 {
            hourText = "hours"
        }

        if prepTime.minute == 1 {
            minuteText = "minute"
        } else if prepTime.minute > 1 {
            minuteText = "minutes"
        }

        if prepTime.hour > 0 && prepTime.minute > 0 {
            return "\(prepTime.hour) \(hourText) \(prepTime.minute) \(minuteText)"
        } else if prepTime.hour > 0 {
            return "\(prepTime.hour) \(hourText)"
        } else if prepTime.minute > 0 {
            return "\(prepTime.minute) \(minuteText)"
        } else {
            return "0 minutes"
        }
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
