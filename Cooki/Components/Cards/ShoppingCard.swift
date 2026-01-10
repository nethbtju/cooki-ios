//
//  ShoppingCard.swift
//  Cooki
//
//  Created by Neth Botheju on 4/1/2026.
//
import SwiftUI

/// Reusable card for displaying items with image, title, and metadata
struct ShoppingCard: View {
    let imageName: String
    let title: String
    let numberOfItems: Int
    let addedUser: User?
    let isAISuggested: Bool
    
    var onDelete: () -> Void
    var onQuantityChange: ((Int) -> Void)?
    var onCartToggle: (() -> Void)?
    
    @State private var showDeleteAlert = false
    @State private var showQuantityEditor = false
    @State private var localQuantity: Int
    @State private var bounceScale: CGFloat = 1.0
    @State private var addedToCart = false
    
    // Fixed height for consistent grid layout
    private let cardHeight: CGFloat = 160
    
    init(
        image: String,
        title: String,
        numberOfItems: Int,
        addedUser: User? = nil,
        isAISuggested: Bool = false,
        onDelete: @escaping () -> Void = {},
        onQuantityChange: ((Int) -> Void)? = nil,
        onCartToggle: (() -> Void)? = nil
    ) {
        self.imageName = image
        self.title = title
        self.numberOfItems = numberOfItems
        self.addedUser = addedUser
        self.isAISuggested = isAISuggested
        self.onDelete = onDelete
        self.onQuantityChange = onQuantityChange
        self.onCartToggle = onCartToggle
        self._localQuantity = State(initialValue: numberOfItems)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main card content
            VStack {
                HStack {
                    // Left side - Image
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 60, minHeight: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Middle - Title and metadata
                    VStack(alignment: .leading, spacing: 8) {
                        // Title with 2-line limit and ellipsis
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.textBlack)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        // Quantity badge
                        HStack(spacing: 4) {
                            Text("Qty:")
                                .font(.system(size: 12, weight: .medium))
                            Text("\(localQuantity)")
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.textGreyDark)
                        .padding(6)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(16)
                        .onTapGesture {
                            showQuantityEditor = true
                        }
                    }
                }
                
                HStack {
                    // User attribution pill
                    VStack {
                        if addedUser != nil || isAISuggested {
                            UserPill(addedUser: addedUser, isAISuggested: isAISuggested)
                        }
                    }
                    .frame(height: 20)
                    
                    Spacer()
                    
                    AddedToCartButton(
                        addedToCart: $addedToCart,
                        bounceScale: $bounceScale
                    )
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            addedToCart.toggle()
                            bounceScale = 1.2
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                bounceScale = 1.0
                            }
                        }
                        
                        onCartToggle?()
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: cardHeight)
            .background(Color(.white))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
            )
            
            // Delete button overlay (top right)
            Button(action: { showDeleteAlert = true }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.textGreyDark)
                    .frame(width: 20, height: 20)
                    .background(Color(.white))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            }
            .offset(x: -8, y: 8)
        }
        .alert("Remove Item", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to remove \"\(title)\" from your shopping list?")
        }
        .sheet(isPresented: $showQuantityEditor) {
            QuantityEditorSheet(quantity: $localQuantity)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
                .onDisappear {
                    onQuantityChange?(localQuantity)
                }
        }
    }
}

// MARK: - User Pill
struct UserPill: View {
    let addedUser: User?
    let isAISuggested: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            if isAISuggested {
                // AI sparkle icon
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Cooki")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            } else if let user = addedUser {
                // User profile with automatic fallback
                user.getProfilePicture(size: 20)
                
                Text(user.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondaryPurple)
            }
        }
        .padding(.leading, 6)
        .padding(.vertical, 6)
        .padding(.trailing, 12)
        .background(Color.secondaryPurple.opacity(0.15))
        .cornerRadius(20)
    }
}

// MARK: - Preview
struct ShoppingCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 6),
                    GridItem(.flexible(), spacing: 6)
                ],
                spacing: 6
            ) {
                // Regular user item
                ShoppingCard(
                    image: "Bananas",
                    title: "Cavendish Bananas",
                    numberOfItems: 6,
                    addedUser: MockData.user,
                    onDelete: { print("Delete tapped") }
                )
                
                // Item with long title
                ShoppingCard(
                    image: "oranges",
                    title: "Cadbury Twirl Milk Chocolate",
                    numberOfItems: 2,
                    addedUser: MockData.user,
                    onDelete: { print("Delete tapped") }
                )
                
                // AI suggested item
                ShoppingCard(
                    image: "basil",
                    title: "Fresh Basil",
                    numberOfItems: 1,
                    isAISuggested: true,
                    onDelete: { print("Delete tapped") }
                )
                
                // Another user
                ShoppingCard(
                    image: "cheese",
                    title: "Cadbury Twirl Milk Chocolate",
                    numberOfItems: 2,
                    addedUser: MockData.user,
                    onDelete: { print("Delete tapped") }
                )
            }
            .padding(12)
        }
        .background(Color(.white))
    }
}
