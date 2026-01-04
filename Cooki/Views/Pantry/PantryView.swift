//
//  PantryView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//  Refactored by Rohit Valanki on 13/12/2025.
//

import SwiftUI

// MARK: - Shared card size constants
struct CardSize {
    static let gridWidth: CGFloat = (UIScreen.main.bounds.width - 20*2 - 10*2) / 3
    static let listWidth: CGFloat = UIScreen.main.bounds.width - 40
    static let height: CGFloat = 170
}

struct PantryView: View {
    @State private var searchText = ""
    @State private var selectedOption: String = "All"
    @State private var isGridView = true
    
    let filterOptions = ["All", "Sort by location", "Filter"]
    
    // Use ViewModel as source of truth
    @StateObject private var viewModel = PantryViewModel()
    
    // Alert state
    @State private var showNewSectionAlert = false
    @State private var newSectionName = ""
    
    // MARK: - Computed properties
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return viewModel.pantryItems
        } else {
            return viewModel.pantryItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private var columns: [GridItem] {
        if isGridView {
            return Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
        } else {
            return [GridItem(.flexible(), spacing: 0)]
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            
            VStack {
                VStack(spacing: 10) {
                    SearchBar(text: $searchText, placeholder: "Search pantry items")
                        .padding(.top, 5)
                    
                    // MARK: - Filter & Toggle Buttons
                    HStack {
                        HStack(spacing: 12) {
                            ForEach(filterOptions, id: \.self) { option in
                                ToggleButton(
                                    title: option,
                                    isSelected: Binding(
                                        get: { selectedOption == option },
                                        set: { _ in selectedOption = option }
                                    )
                                )
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            if selectedOption == "Sort by location" {
                                Button(action: {
                                    newSectionName = ""
                                    showNewSectionAlert = true
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color.gray)
                                        .frame(width: 36, height: 36)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                .alert("New Section", isPresented: $showNewSectionAlert, actions: {
                                    TextField("Section name", text: $newSectionName)
                                    Button("Add") { }
                                    Button("Cancel", role: .cancel) { }
                                }, message: { Text("Enter a name for the new section") })
                            }
                            
                            Button(action: { isGridView.toggle() }) {
                                Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color.gray)
                                    .frame(width: 36, height: 36)
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                    .animation(.easeInOut(duration: 0.25), value: selectedOption)
                    
                    // MARK: - Pantry Items Grid/List
                    ScrollView(.vertical, showsIndicators: false) {
                        if selectedOption == "Sort by location" {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(viewModel.sections, id: \.self) { section in
                                    SectionView(
                                        title: section,
                                        items: viewModel.items(for: section),
                                        isGridView: isGridView
                                    )
                                }
                            }
                            .padding(.bottom, 130)
                        } else {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(filteredItems) { item in
                                    ItemCard.pantryItem(item)
                                }
                            }
                            .padding(.top, 4)
                            .padding(.bottom, 130)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}

// MARK: - SectionView
struct SectionView: View {
    let title: StorageLocation
    let items: [Item]
    let isGridView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.rawValue)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items) { item in
                        ItemCard.pantryItem(item)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Preview
struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
