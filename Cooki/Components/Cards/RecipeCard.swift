//
//  SuggestMealCard.swift
//  Cooki
//
//  Created by Neth Botheju on 17/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//  Optimized for compile-time performance
//
import SwiftUI

/// Card for displaying recipe/meal information with action button
struct RecipeCard: View {
    let metadata: RecipeMetadata
    let actionButton: ActionButtonConfiguration
    let layout: LayoutStyle
    
    init(
        metadata: RecipeMetadata,
        actionButton: ActionButtonConfiguration,
        layout: LayoutStyle = .vertical
    ) {
        self.metadata = metadata
        self.actionButton = actionButton
        self.layout = layout
    }
    
    enum LayoutStyle {
        case vertical
        case horizontal
    }
    
    struct RecipeMetadata {
        let recipe: Recipe
        let date: Date?
        let aiSuggestion: String?
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
            recipeImage(minHeight: 124)
            
            VStack(alignment: .center, spacing: 8) {
                recipeTitle
                metadataRow
                actionButtonView
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
        .frame(minWidth: 180, maxWidth: 180)
    }
    
    // MARK: - Horizontal Layout (SuggestMealCard style)
    private var horizontalLayout: some View {
        HStack(spacing: 16) {
            recipeImage(minHeight: 100)
                .frame(width: 140)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                recipeTitle
                metadataRow
                
                if let aiSuggestion = metadata.aiSuggestion {
                    aiSuggestionBadge(aiSuggestion)
                }
                
                actionButtonView
                    .padding(.top, 6)
            }
            .frame(alignment: .leading)
            .padding(.vertical, 8)
            .padding(.trailing, 16)
        }
        .frame(maxHeight: (metadata.aiSuggestion != nil) ? 140 : 110)
    }
    
    // MARK: - Shared Components
    private func recipeImage(minHeight: CGFloat) -> some View {
        Image(metadata.recipe.imageName)
            .resizable()
            .scaledToFill()
            .frame(minHeight: minHeight)
            .clipped()
    }
    
    private var recipeTitle: some View {
        Text(metadata.recipe.title)
            .font(layout == .vertical ? AppFonts.cardTitle() : AppFonts.heading2())
            .foregroundColor(layout == .vertical ? .primary : .textBlack)
            .lineLimit(layout == .horizontal ? 1 : nil)
    }
    
    // MARK: - Metadata Row (Optimized)
    private var metadataRow: some View {
        HStack(spacing: 2) {
            clockIcon
            timeOrDateText
            
            if shouldShowSeparator {
                separatorDot
            }
            
            if metadata.recipe.servings > 0 {
                servingsText
            }
        }
    }
    
    private var clockIcon: some View {
        Image(systemName: "clock")
            .foregroundStyle(Color.textGrey3)
            .font(.system(size: 12))
    }
    
    @ViewBuilder
    private var timeOrDateText: some View {
        if metadata.recipe.totalTime > 0 {
            Text(metadata.recipe.formattedTotalTime.string(.long))
                .font(AppFonts.smallBody())
                .foregroundColor(.textGrey2)
        } else if let date = metadata.date {
            Text(date.day)
                .font(AppFonts.smallBody())
                .foregroundColor(.textGrey2)
        }
    }
    
    private var separatorDot: some View {
        Image(systemName: "circle.fill")
            .foregroundColor(.textGrey2)
            .font(.system(size: 4))
            .padding(.horizontal, 4)
    }
    
    private var servingsText: some View {
        Text("\(metadata.recipe.servings) servings")
            .font(AppFonts.smallBody())
            .foregroundColor(.textGrey2)
    }
    
    private var shouldShowSeparator: Bool {
        metadata.recipe.servings > 0 && (metadata.recipe.totalTime > 0 || metadata.date != nil)
    }
    
    // MARK: - Action Button (Optimized)
    private var actionButtonView: some View {
        Button(action: actionButton.action) {
            actionButtonContent
        }
        .shadow(radius: 2)
        .frame(maxWidth: layout == .horizontal ? .infinity : nil)
    }
    
    private var actionButtonContent: some View {
        HStack(spacing: 8) {
            if let icon = actionButton.icon {
                actionIcon(icon)
            }

            Text(actionButton.title)
                .font(AppFonts.buttonFontSmall())
                .fontWeight(.bold)
                .foregroundColor(.accentLightOrange)

            if shouldAddSpacer {
                Spacer()
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 6)
        .frame(
            maxWidth: .infinity,
            alignment: actionButton.icon == nil ? .center : .leading
        )
        .background(.white)
        .clipShape(Capsule())
    }
    
    private func actionIcon(_ icon: String) -> some View {
        Image(systemName: icon)
            .foregroundStyle(Color.white)
            .font(.system(size: 8, weight: .bold))
            .padding(3)
            .background(Circle().fill(Color.accentBurntOrange))
    }
    
    private var buttonBorder: some View {
        Capsule().stroke(
            layout == .vertical ? Color.clear : Color.textGrey.opacity(0.5),
            lineWidth: 1
        )
    }
    
    private var shouldAddSpacer: Bool {
        layout == .horizontal && actionButton.icon != nil
    }
    
    // MARK: - AI Suggestion Badge
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
        recipeData: Recipe,
        date: Date,
        action: @escaping () -> Void
    ) -> RecipeCard {
        RecipeCard(
            metadata: RecipeMetadata(
                recipe: recipeData,
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
        action: @escaping () -> Void
    ) -> RecipeCard {
        RecipeCard(
            metadata: RecipeMetadata(
                recipe: recipeSuggestion.recipe,
                date: nil,
                aiSuggestion: recipeSuggestion.displayMessage
            ),
            actionButton: ActionButtonConfiguration(
                title: "Add to meal plan",
                icon: "plus",
                action: action
            ),
            layout: .horizontal
        )
    }
    
    enum Context {
        case home
        case plan
    }
    
    static func mealPlan(
        type: Context,
        plannedMeal: Recipe,
        date: Date,
        action: @escaping () -> Void
    ) -> RecipeCard {
        RecipeCard(
            metadata: RecipeMetadata(
                recipe: plannedMeal,
                date: date,
                aiSuggestion: nil
            ),
            actionButton: ActionButtonConfiguration(
                title: "Start Cooking",
                icon: nil,
                action: action
            ),
            layout: type == .home ? .vertical : .horizontal
        )
    }
}

// MARK: - Preview
struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RecipeCard.cooking(
                recipeData: MockData.recipes[0],
                date: Date(),
                action: { print("Start cooking") }
            )
            
            RecipeCard.suggestion(
                recipeSuggestion: MockData.suggestions[1],
                action: { print("Add to meal plan") }
            )
            
            RecipeCard.mealPlan(
                type: .home,
                plannedMeal: MockData.recipes[0],
                date: Date(),
                action: { print("Add to meal plan") }
            )
            
            RecipeCard.mealPlan(
                type: .plan,
                plannedMeal: MockData.recipes[0],
                date: Date(),
                action: { print("Add to meal plan") }
            )
        }
        .padding()
    }
}
