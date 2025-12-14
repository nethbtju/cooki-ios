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
    let suggestions = MockData.suggestions
    let pantryItems = MockData.pantryItems
    var notificationText: String? = nil
    var upcomingRecipes: [Recipe] {
        let today = Calendar.current.startOfDay(for: Date())
        let daysAhead = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        
        return MealPlan.mockMealPlans
            .filter { ($0.date >= today) && ($0.date <= daysAhead) }
            .flatMap { $0.planData.values }
            .flatMap { $0 }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    if notificationText != "" && showBanner {
                        NotificationBanner(showBanner: $showBanner, text: notificationText)
                            .padding(.top, 24)
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
                                        ItemCard.pantryItem(pantryItem)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                        }
                        .padding(.top, 16)
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
                                    ForEach(upcomingRecipes) { plannedMeal in
                                        RecipeCard.mealPlan(
                                            type: .home,
                                            plannedMeal: plannedMeal.recipe,
                                            date: plannedMeal.scheduledDate,
                                            action: { print("Start cooking \(plannedMeal.recipe.title)") }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
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
                                    ForEach(suggestions) { suggestion in RecipeCard.suggestion(
                                        recipeSuggestion: suggestion,
                                        action: {
                                            print ("mao")
                                        }
                                    )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                        }
                        Spacer().frame(height: 150)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showBanner)
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
