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
        ZStack() {
            // Main card content
            VStack {
                HStack {
                    // Left side - Image
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Middle - Title and metadata
                    VStack(alignment: .leading) {
                        HStack {
                            // Title with 2-line limit and ellipsis
                            Text(title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.textBlack)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 6)
                            
                            VStack {
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
                                
                                Spacer()
                                
                            }
                        }
                        
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
            .padding(8)
        }
        .background(Color.backgroundGrey)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        HStack(spacing: 0) {
            leadingIcon
                .frame(width: 20, height: 20)

            labelText
                .padding(.trailing, 4)
        }
        .padding(.horizontal, 6)
        .frame(minHeight: 28)
        .background(Color.secondaryPurple.opacity(0.15))
        .clipShape(Capsule())
    }

    // MARK: - Leading Icon (fixed 20x20, always left)
    @ViewBuilder
    private var leadingIcon: some View {
        if isAISuggested {
            Image(systemName: "sparkles")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(gradient)
        } else if let user = addedUser {
            user.getProfilePicture(size: 20)
        }
    }

    // MARK: - Label (expands pill to the right)
    @ViewBuilder
    private var labelText: some View {
        if isAISuggested {
            Text("Cooki")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(gradient)
        } else {
            Text(addedUser?.displayName ?? "")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondaryPurple)
                .padding(.leading, 4)
        }
    }

    // MARK: - Shared Gradient
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [.purple, .blue, .pink],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Preview
struct ShoppingCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
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
