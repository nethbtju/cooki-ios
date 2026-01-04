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
    
    @StateObject private var viewModel = PantryViewModel()
    
    @State private var showNewSectionAlert = false
    @State private var newSectionName = ""
    
    private var filteredItems: [Item] {
        searchText.isEmpty
        ? viewModel.pantryItems
        : viewModel.pantryItems.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    private var columns: [GridItem] {
        isGridView
        ? Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
        : [GridItem(.flexible(), spacing: 0)]
    }
    
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 10) {
                SearchBar(text: $searchText, placeholder: "Search pantry items")
                    .padding(.top, 5)
                
                // Filters
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
                    
                    Button(action: { isGridView.toggle() }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 2)
                
                // MARK: - Content
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        // LOADING
                        if viewModel.isLoading {
                            SkeletonGrid()
                        }
                        // EMPTY
                        else if viewModel.pantryItems.isEmpty {
                            EmptyPantryWatermark()
                        }
                        // CONTENT
                        else if selectedOption == "Sort by location" {
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
            }
            .padding(20)
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
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items) { item in
                        ItemCard.pantryItem(item)
                    }
                }
            }
        }
    }
}

// MARK: - Empty Pantry Watermark
struct EmptyPantryWatermark: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.35))
            
            Text("No items yet")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.gray.opacity(0.45))
        }
        .padding(.top, 80)
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
