//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//
//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//

import SwiftUI

struct HomeView: View {
    
    let recipes = Recipe.mockRecipes
    let suggestions = Suggestion.mockSuggestion
    var body: some View {
        ZStack {
            // MARK: Background
            Color.secondaryPurple
                .ignoresSafeArea()
            
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 1.4,
                       height: UIScreen.main.bounds.height * 1.1,
                       alignment: .top)
                .clipped()
                .ignoresSafeArea()

            // MARK: Content
            VStack {
                // Header bar
                HStack {
                    // Left side
                    HStack(spacing: 10) {
                        Image("CookieMiniIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                        
                        Text("Hello, Neth")
                            .foregroundColor(.backgroundWhite)
                            .font(AppFonts.heading2())
                    }
                    
                    Spacer().frame(width: 160)
                    
                    // Right side
                    ProfileIcon(image: Image("ProfilePic"), size: 50)
                }
              
                Spacer().frame(height: 28)
                
                // Modal sheet
                ModalSheet(
                    heightFraction: 0.80,
                    cornerRadius: 27,
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading) {
                                NotificationBanner(text: "4 items in pantry expiring soon!").padding(.top, 24)
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
                                
                            }
//                            Spacer()
                        }
                    }
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
