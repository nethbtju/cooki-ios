//
//  MealPlanView.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct MealPlanView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Your Meal Plan")
                    .font(AppFonts.heading3())
                    .foregroundStyle(Color.backgroundWhite)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 36)
            .padding(.bottom, 2)
            
            // Modal sheet
            ModalSheet(
                heightFraction: 0.87,
                cornerRadius: 27,
                content: {
                    VStack {
                        Text("mao")
                    }
                }
            )
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .offset(x: -50, y: -50)
                .ignoresSafeArea()
        }
        .background(Color.secondaryPurple)
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}

