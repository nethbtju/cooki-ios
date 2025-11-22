//
//  SuggestMealCard.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import SwiftUI

/// Card for displaying recipe/meal information with action button
struct RecipeCard: View {
    let imageName: String
    let title: String
    let metadata: RecipeMetadata
    let actionButton: ActionButtonConfiguration
    let layout: LayoutStyle
    
    init(
        imageName: String = "default_image", // TODO: Add default image
        title: String,
        metadata: RecipeMetadata,
        actionButton: ActionButtonConfiguration,
        layout: LayoutStyle = .vertical
    ) {
        self.imageName = imageName
        self.title = title
        self.metadata = metadata
        self.actionButton = actionButton
        self.layout = layout
    }
    
    enum LayoutStyle {
        case vertical
        case horizontal
    }
    
    struct RecipeMetadata {
        let prepTime: (hours: Int, minutes: Int)?
        let servings: Int
        let date: String?
        let aiSuggestion: String?
        
        var formattedPrepTime: String? {
            guard let prepTime = prepTime else { return nil }
            return TimeFormatter.formatPrepTime(hours: prepTime.hours, minutes: prepTime.minutes)
        }
    }
    
    struct ActionButtonConfiguration {
        let title: String
        let icon: String?
        let action: () -> Void
    }
    
    var body: some View {
        Group {
            switch layout {
            case .vertical:
                verticalLayout
            case .horizontal:
                horizontalLayout
            }
        }
        .cardStyle()
    }
    
    // MARK: - Vertical Layout (CookingCard style)
    private var verticalLayout: some View {
        VStack(spacing: 0) {
            // Image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 124)
                .clipped()
            
            VStack(alignment: .center, spacing: 8) {
                // Title
                Text(title)
                    .font(AppFonts.cardTitle())
                    .foregroundColor(.primary)
                
                // Metadata row
                metadataRow
                
                // Action button
                actionButtonView
            }
            .padding(.bottom, 14)
            .padding(.top, 6)
        }
        .frame(minWidth: 180, maxWidth: 180)
    }
    
    // MARK: - Horizontal Layout (SuggestMealCard style)
    private var horizontalLayout: some View {
        HStack(spacing: 6) {
            // Image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 120)
                .cornerRadius(8)
                .padding(16)
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(title)
                    .font(AppFonts.heading2())
                    .lineLimit(1)
                    .foregroundStyle(Color.textBlack)
                
                // Metadata row
                metadataRow
                
                // AI Suggestion badge
                if let aiSuggestion = metadata.aiSuggestion {
                    aiSuggestionBadge(aiSuggestion)
                }
                
                // Action button
                actionButtonView
                    .padding(.top, 6)
            }
            .padding(.trailing, 16)
        }
    }
    
    // MARK: - Subviews
    private var metadataRow: some View {
        HStack(spacing: 2) {
            if layout == .horizontal {
                Image(systemName: "clock")
                    .foregroundStyle(Color.textGrey3)
                    .font(.system(size: 12))
            }
            
            if let formattedTime = metadata.formattedPrepTime {
                Text(formattedTime)
                    .font(AppFonts.smallBody())
                    .foregroundColor(.textGrey2)
                
                if metadata.servings > 0 {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.textGrey2)
                        .font(.system(size: 4))
                        .padding(.horizontal, 4)
                }
            } else if let date = metadata.date {
                Text(date)
                    .font(AppFonts.smallBody())
                    .foregroundColor(.textGrey2)
                
                if metadata.servings > 0 {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.textGrey2)
                        .font(.system(size: 4))
                        .padding(.horizontal, 4)
                }
            }
            
            if metadata.servings > 0 {
                Text("\(metadata.servings) servings")
                    .font(AppFonts.smallBody())
                    .foregroundColor(.textGrey2)
            }
        }
    }
    
    private var actionButtonView: some View {
        Button(action: actionButton.action) {
            HStack(spacing: 8) {
                if let icon = actionButton.icon {
                    Image(systemName: icon)
                        .foregroundStyle(layout == .vertical ? Color.white : Color.white)
                        .font(.system(size: 8, weight: .bold))
                        .padding(3)
                        .background(
                            Circle()
                                .fill(Color.accentBurntOrange)
                        )
                }
                
                Text(actionButton.title)
                    .font(AppFonts.buttonFontSmall())
                    .fontWeight(.bold)
                    .foregroundColor(layout == .vertical ? .accentLightOrange : .accentLightOrange)
                
                if layout == .horizontal {
                    Spacer()
                }
            }
            .padding(layout == .vertical ? .horizontal : .all, layout == .vertical ? 30 : 4)
            .padding(layout == .vertical ? 4 : 4)
            .background(.white)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(
                    layout == .vertical ? Color.clear : Color.textGrey.opacity(0.5),
                    lineWidth: 1
                )
            )
        }
        .shadow(radius: layout == .vertical ? 2 : 0)
    }
    
    private func aiSuggestionBadge(_ text: String) -> some View {
        Text(text)
            .font(AppFonts.smallBody2())
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.accentPeach.opacity(0.5))
            .foregroundStyle(Color.textGrey3)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentPeach, lineWidth: 1)
            )
    }
}

// MARK: - Convenience Initializers
extension RecipeCard {
    /// Create a cooking card (vertical layout)
    static func cooking(
        recipe: Recipe,
        date: String,
        action: @escaping () -> Void
    ) -> RecipeCard {
        RecipeCard(
            imageName: recipe.imageName,
            title: recipe.title,
            metadata: RecipeMetadata(
                prepTime: nil,
                servings: recipe.servings,
                date: date,
                aiSuggestion: nil
            ),
            actionButton: ActionButtonConfiguration(
                title: "Start Cooking",
                icon: nil,
                action: action
            ),
            layout: .vertical
        )
    }
    
    /// Create a meal suggestion card (horizontal layout)
    static func suggestion(
        recipeSuggestion: RecipeSuggestion,
        aiSuggestion: String,
        action: @escaping () -> Void
    ) -> RecipeCard {
        RecipeCard(
            imageName: recipeSuggestion.recipe.imageName,
            title: recipeSuggestion.recipe.title,
            metadata: RecipeMetadata(
                prepTime: recipeSuggestion.recipe.formattedTotalTime,
                servings: recipeSuggestion.recipe.servings,
                date: nil,
                aiSuggestion: aiSuggestion
            ),
            actionButton: ActionButtonConfiguration(
                title: "Add to meal plan",
                icon: "plus",
                action: action
            ),
            layout: .horizontal
        )
    }
}

// MARK: - Preview
struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Cooking card
            RecipeCard.cooking(
                recipe: MockData.recipes[0],
                date: "Sat",
                action: { print("Start cooking") }
            )
            
            // Suggestion card
            RecipeCard.suggestion(
                recipeSuggestion: MockData.suggestions[1],
                aiSuggestion: "Meet your protein goals with this meal",
                action: { print("Add to meal plan") }
            )
        }
        .padding()
    }
}
