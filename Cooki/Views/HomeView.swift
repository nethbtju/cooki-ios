//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//
import SwiftUI

struct HomeView: View {
    
    @State private var showBanner = true
    let recipes = Recipe.mockRecipes
    let suggestions = Suggestion.mockSuggestion
    let pantryItems = FoodItem.mockFoodItem
    var notificationText: String? = nil
    
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal(radius: 30))
                .ignoresSafeArea(edges: .bottom) // keep safe area at bottom if needed
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    if notificationText != "" {
                        NotificationBanner(text: notificationText)
                            .padding(.top, 24)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onTapGesture {
                                withAnimation {
                                    showBanner = false
                                }
                            }
                    } else {
                        Spacer()
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center) {
                            Text("Your Stock")
                                .font(AppFonts.heading())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textBlack)
                            Text("Your pantry at a glance")
                                .font(AppFonts.smallBody())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textGrey2)
                                .padding(.bottom, 6)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(pantryItems, id: \.title) { pantryItem in
                                        PantryItemCard(
                                            imageName: pantryItem.imageName,
                                            title: pantryItem.title,
                                            quantity: pantryItem.quantity,
                                            daysLeft: pantryItem.daysLeft
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        VStack(alignment: .center) {
                            Text("Let's cook")
                                .font(AppFonts.heading())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textBlack)
                            Text("Get started on your meal plan")
                                .font(AppFonts.smallBody())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textGrey2)
                                .padding(.bottom, 6)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(recipes, id: \.title) { recipe in
                                        CookingCard(
                                            image: recipe.image,
                                            title: recipe.title,
                                            date: recipe.day,
                                            serving: recipe.servings,
                                            action: ({ print("Tapped!") })
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        VStack(alignment: .center) {
                            Text("Meal suggestions")
                                .font(AppFonts.heading())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textBlack)
                            Text("Tailored for you to eat your best")
                                .font(AppFonts.smallBody())
                                .lineLimit(1)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .foregroundStyle(Color.textGrey2)
                                .padding(.bottom, 6)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(suggestions, id: \.title) { suggestion in
                                        SuggestMealCard(
                                            image: suggestion.image,
                                            title: suggestion.title,
                                            prepTime: suggestion.prepTime,
                                            serving: suggestion.servings,
                                            action: ({ print("Tapped!") }),
                                            aiSuggestionText: suggestion.aiText
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Spacer().frame(height: 150)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(notificationText: "4 items in pantry expiring soon!")
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
