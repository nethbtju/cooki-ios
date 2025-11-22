//
//  PantryView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
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
    
    @State private var pantryItems = PantryItem.mockPantrytems
    
    @State private var sections: [String] = ["Pantry", "Fridge", "Freezer"]
    
    // Alert state
    @State private var showNewSectionAlert = false
    @State private var newSectionName = ""
    
    // MARK: - Computed properties
    var filteredItems: [PantryItem] {
        if searchText.isEmpty {
            return pantryItems
        } else {
            return pantryItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var columns: [GridItem] {
        if isGridView {
            return Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
        } else {
            return [GridItem(.flexible(), spacing: 0)]
        }
    }
    
    // MARK: - Helper method
    private func createSection(title: String) -> SectionView {
        SectionView(
            title: title,
            items: filteredItems.filter { $0.location == title },
            isGridView: isGridView
        )
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
                    
                    HStack {
                        // Filter buttons
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
                        
                        // + button and toggle button grouped with 0 spacing
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
                                    Button("Add") {
                                        if !newSectionName.isEmpty {
                                            sections.append(newSectionName)
                                        }
                                    }
                                    Button("Cancel", role: .cancel) { }
                                }, message: {
                                    Text("Enter a name for the new section")
                                })
                            }
                            
                            Button(action: {
                                isGridView.toggle()
                            }) {
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
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        if selectedOption == "Sort by location" {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(sections, id: \.self) { section in
                                    createSection(title: section)
                                }
                            }
                            .padding(.bottom, 130)
                        } else {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(filteredItems) { filteredItem in
                                    PantryItemCard(
                                        pantryItem: filteredItem
                                    )
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
    let title: String
    let items: [PantryItem]
    let isGridView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items) { item in
                        PantryItemCard(
                            pantryItem: item
                        )
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
