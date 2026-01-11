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
    @State private var items: [Item] = Item.mockItems
    @State private var isCheckedOut = false
    
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
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                ScrollView {
                    if items.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "cart")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No items in your shopping list")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(items) { item in
                                ShoppingCard(
                                    image: item.imageName ?? "default",
                                    title: item.title,
                                    numberOfItems: 1,
                                    addedUser: MockData.users[0],
                                    isAISuggested: false,
                                    onDelete: { deleteItem(item) }
                                )
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CheckoutFloatingButton(isCheckedOut: $isCheckedOut) {
                        isCheckedOut.toggle()
                        print("Checkout tapped - isCheckedOut: \(isCheckedOut)")
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private func deleteItem(_ item: Item) {
        withAnimation {
            items.removeAll { $0.id == item.id }
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
