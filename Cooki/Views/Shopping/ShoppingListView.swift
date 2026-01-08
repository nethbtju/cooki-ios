//
//  ShoppingListView.swift
//  Cooki
//
//  Created by Neth Botheju on 4/1/2026.
//
import SwiftUI

struct ShoppingListView: View {
    
    @State private var searchText = ""
    @State private var isGridView = true
    @StateObject private var viewModel = MealPlanViewModel()
    
    let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // Search bar
                    SearchBar(text: $searchText, placeholder: "Search shopping list items")
                        .padding(.top, 5)
                    
                    // List toggle
                    Button(action: { isGridView.toggle() }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(items) { item in
                                ShoppingCard(
                                    image: Image(item.imageName),
                                    title: item.title,
                                    quantity: $items[items.firstIndex(where: { $0.id == item.id })!].quantity,
                                    addedToCart: $items[items.firstIndex(where: { $0.id == item.id })!].addedToCart,
                                    addedUser: item.user,
                                    isAISuggested: item.isAISuggested,
                                    onDelete: { deleteItem(item) }
                                )
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
            }
        }
    }
}
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}


