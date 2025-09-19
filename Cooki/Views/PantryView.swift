//
//  PantryView.swift
//  Cooki
//
//  Created by Rohit Valanki on 10/9/2025.
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
    
    // State for modal sheet
    @State private var selectedItem: (image: String, name: String, qty: Int, expiry: Int, location: String)?
    @State private var isModalPresented = false
    
    let filterOptions = ["All", "Sort by location", "Filter"]
    
    let pantryItems: [(image: String, name: String, qty: Int, expiry: Int, location: String)] = [
        ("StrawberryJam", "Apples", 6, 3, "Pantry"),
        ("Bananas", "Bananas", 4, 1, "Pantry"),
        ("Milk", "Milk", 1, -1, "Fridge"),
        ("Bananas", "Eggs", 12, 7, "Fridge"),
        ("StrawberryJam", "Bread", 2, 2, "Pantry"),
        ("Milk", "Cheese", 1, 10, "Fridge"),
        ("StrawberryJam", "Yogurt", 3, 5, "Fridge"),
        ("Bananas", "Tomatoes", 8, 2, "Pantry"),
        ("Milk", "Ice Cream", 2, 20, "Freezer"),
        ("Bananas", "Frozen Peas", 1, 15, "Freezer"),
        ("StrawberryJam", "Apples", 6, 3, "Pantry"),
        ("Milk", "Bananas", 4, 1, "Pantry"),
        ("StrawberryJam", "Milk", 1, -1, "Fridge"),
        ("Bananas", "Eggs", 12, 7, "Fridge"),
        ("Milk", "Bread", 2, 2, "Pantry"),
        ("Bananas", "Cheese", 1, 10, "Fridge"),
        ("StrawberryJam", "Yogurt", 3, 5, "Fridge"),
        ("Milk", "Tomatoes", 8, 2, "Pantry"),
        ("StrawberryJam", "Ice Cream", 2, 20, "Freezer"),
        ("Bananas", "Frozen Peas", 1, 15, "Freezer")
    ]
    
    var filteredItems: [(image: String, name: String, qty: Int, expiry: Int, location: String)] {
        if searchText.isEmpty {
            return pantryItems
        } else {
            return pantryItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var columns: [GridItem] {
        if isGridView {
            return Array(repeating: GridItem(.fixed(CardSize.gridWidth), spacing: 10), count: 3)
        } else {
            return [GridItem(.flexible(), spacing: 0)]
        }
    }
    
    var body: some View {
        ZStack {
            Color.secondaryPurple
                .ignoresSafeArea()
            
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .frame(
                    width: UIScreen.main.bounds.width * 1.4,
                    height: UIScreen.main.bounds.height * 1.1,
                    alignment: .top
                )
                .clipped()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack(alignment: .topLeading) {
                    ModalSheet(
                        heightFraction: 0.90,
                        cornerRadius: 27,
                        content: {
                            VStack(spacing: 10) {
                                SearchBar(text: $searchText, placeholder: "Search pantry items")
                                    .padding(.top, 5)
                                
                                HStack(spacing: 12) {
                                    ForEach(filterOptions, id: \.self) { option in
                                        FilterButton(
                                            title: option,
                                            isSelected: Binding(
                                                get: { selectedOption == option },
                                                set: { _ in selectedOption = option }
                                            )
                                        )
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isGridView.toggle()
                                    }) {
                                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color.gray)
                                            .frame(width: 40, height: 36)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal, 2)
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    if selectedOption == "Sort by location" {
                                        VStack(alignment: .leading, spacing: 10) {
                                            SectionView(
                                                title: "Pantry",
                                                items: filteredItems.filter { $0.location == "Pantry" },
                                                isGridView: isGridView,
                                                onCardTap: showModal
                                            )
                                            SectionView(
                                                title: "Fridge",
                                                items: filteredItems.filter { $0.location == "Fridge" },
                                                isGridView: isGridView,
                                                onCardTap: showModal
                                            )
                                            SectionView(
                                                title: "Freezer",
                                                items: filteredItems.filter { $0.location == "Freezer" },
                                                isGridView: isGridView,
                                                onCardTap: showModal
                                            )
                                        }
                                        .padding(.bottom, 130)
                                    } else {
                                        LazyVGrid(columns: columns, spacing: 12) {
                                            ForEach(filteredItems.indices, id: \.self) { index in
                                                let item = filteredItems[index]
                                                
                                                FoodCard(
                                                    imageName: item.image,
                                                    title: item.name,
                                                    quantity: item.qty,
                                                    daysToExpiry: item.expiry
                                                )
                                                .frame(width: isGridView ? CardSize.gridWidth : CardSize.listWidth,
                                                       height: CardSize.height)
                                                .padding(.vertical, 0)
                                                .onTapGesture {
                                                    showModal(item: item)
                                                }
                                            }
                                        }
                                        .padding(.top, 4)
                                        .padding(.bottom, 130)
                                    }
                                }
                            }
                            .padding(20)
                        }
                    )
                    
                    Text("Your Pantry")
                        .font(AppFonts.heading())
                        .foregroundColor(.white)
                        .padding(.top, -50)
                        .padding(.leading, 24)
                }
            }
        }
        .sheet(isPresented: $isModalPresented) {
            if let selectedItem = selectedItem {
                FoodDetailModal(item: selectedItem)
            }
        }
    }
    
    // Show modal function
    private func showModal(item: (image: String, name: String, qty: Int, expiry: Int, location: String)) {
        selectedItem = item
        isModalPresented = true
    }
}

// MARK: - SectionView
struct SectionView: View {
    let title: String
    let items: [(image: String, name: String, qty: Int, expiry: Int, location: String)]
    let isGridView: Bool
    var onCardTap: (( (image: String, name: String, qty: Int, expiry: Int, location: String) ) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        
                        FoodCard(
                            imageName: item.image,
                            title: item.name,
                            quantity: item.qty,
                            daysToExpiry: item.expiry
                        )
                        .frame(width: isGridView ? CardSize.gridWidth : CardSize.listWidth,
                               height: CardSize.height)
                        .padding(.vertical, 0)
                        .onTapGesture {
                            onCardTap?(item)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Food Detail Modal
struct FoodDetailModal: View {
    let item: (image: String, name: String, qty: Int, expiry: Int, location: String)
    
    // Example placeholder data
    let calories: Int = 250
    let protein: Double = 15
    let carbs: Double = 30
    let fat: Double = 8
    
    let datePurchased: String = "10 Sept 2025"
    let store: String = "Woolworths"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 6)
                
                // Name
                Text(item.name)
                    .font(.title)
                    .bold()
                
                // Calories & Macros Card
                VStack(spacing: 16) {
                    HStack(alignment: .top, spacing: 20) {
                        // Circular macro bar pushed left
                        VStack {
                            MacroCircleView(
                                protein: protein,
                                carbs: carbs,
                                fat: fat,
                                calories: calories
                            )
                            .frame(width: 120, height: 120)
                            
                            // Legend under circle
                            HStack(spacing: 12) {
                                LegendDot(color: .green, label: "Protein")
                                LegendDot(color: .blue, label: "Carbs")
                                LegendDot(color: .orange, label: "Fat")
                            }
                            .font(.caption2)
                            .padding(.top, 6)
                        }
                        
                        // Text info on right
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Calories: \(calories) kcal")
                            Text("Protein: \(Int(protein)) g")
                            Text("Carbs: \(Int(carbs)) g")
                            Text("Fat: \(Int(fat)) g")
                        }
                        .font(.subheadline)
                        .padding(.top, 20) // ⬅️ pushed down further
                    }
                }
                .padding(.top, 28)       // ⬅️ more space on top
                .padding(.bottom, 16)    // ⬅️ keep original bottom height
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color.foodCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Item Details
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Quantity", value: "\(item.qty)")
                    DetailRow(label: "Expires in", value: "\(item.expiry) days")
                    DetailRow(label: "Date Purchased", value: datePurchased)
                    DetailRow(label: "Store", value: store)
                    DetailRow(label: "Location", value: item.location)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.foodCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}



// MARK: - Macro Circle View
struct MacroCircleView: View {
    let protein: Double
    let carbs: Double
    let fat: Double
    let calories: Int
    
    var total: Double {
        protein + carbs + fat
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 18)
            
            // Protein arc
            Circle()
                .trim(from: 0, to: CGFloat(protein / total))
                .stroke(Color.green, lineWidth: 18)
                .rotationEffect(.degrees(-90))
            
            // Carbs arc
            Circle()
                .trim(from: CGFloat(protein / total),
                      to: CGFloat((protein + carbs) / total))
                .stroke(Color.blue, lineWidth: 18)
                .rotationEffect(.degrees(-90))
            
            // Fat arc
            Circle()
                .trim(from: CGFloat((protein + carbs) / total), to: 1)
                .stroke(Color.orange, lineWidth: 18)
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("Calories")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(calories)")
                    .font(.headline)
            }
        }
    }
}

// MARK: - Legend Dot
struct LegendDot: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
        }
    }
}

// MARK: - Reusable row
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
