//
//  ShoppingCard.swift
//  Cooki
//
//  Created by Neth Botheju on 4/1/2026.
//
import SwiftUI

/// Reusable card for displaying items with image, title, and metadata
struct ShoppingCard: View {
    let image: Image
    let title: String
    let addedUser: User?
    @State var quantity: Int
    let isAISuggested: Bool
    
    var onDelete: () -> Void
    
    @State private var showDeleteAlert = false
    @State private var showQuantityEditor = false
    @State private var bounceScale: CGFloat = 1.0
    @State private var addedToCart = false
    
    init(
        image: Image,
        title: String,
        quantity: Int,
        addedUser: User? = nil,
        isAISuggested: Bool = false,
        onDelete: @escaping () -> Void = {}
    ) {
        self.image = image
        self.title = title
        self.quantity = quantity
        self.addedUser = addedUser
        self.isAISuggested = isAISuggested
        self.onDelete = onDelete
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 6) {
                            // Left side - Image
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 70)
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                            
                            // Middle - Title and metadata
                            VStack(alignment: .leading, spacing: 8) {
                                Text(title)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                
                                // Quantity with edit button
                                HStack(spacing: 8) {
                                    Text("Qty: \(quantity)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                    
                                    Button(action: { showQuantityEditor = true }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.purple)
                                            .frame(width: 24, height: 24)
                                            .background(Color.purple.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        UserPill(addedUser: addedUser, isAISuggested: isAISuggested)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Button(action: { showDeleteAlert = true }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.accentBurntOrange)
                                .frame(width: 24, height: 24)
                                .background(Color.backgroundWhite.opacity(0.9))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                        
                        Spacer()
                            .frame(maxHeight: 50)
                        
                        // Cart button anchored to bottom right
                        AddedToCartButton(
                            addedToCart: $addedToCart,
                            bounceScale: $bounceScale
                        )
                    }
                }
                .frame(width: geometry.size.width)
                .padding()
                .cardStyle(
                    CardConfiguration(
                        backgroundColor: .white,
                        cornerRadius: 16,
                        shadowRadius: 6,
                        shadowOpacity: 0.2,
                        borderColor: .textGreyDark.opacity(0.3),
                        borderWidth: 1,
                        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
                    )
                )
            }
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
            QuantityEditorSheet(quantity: $quantity)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
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
                
                Text("Cooki suggests")
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
                    .foregroundColor(.purple)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(16)
    }
}

// MARK: - Preview
struct ShoppingCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Regular user item
            let mockItem = Item.mockItem
            ShoppingCard(
                image: Image(mockItem.imageName ?? "default"),
                title: "Gourmet Tomatoes",
                quantity: 6,
                addedUser: MockData.user,
                onDelete: { print("Delete tapped") }
            )
            
            // Item added to cart
            ShoppingCard(
                image: Image(mockItem.imageName ?? "default"),
                title: "Organic Milk",
                quantity: 2,
                addedUser: MockData.user,
                onDelete: { print("Delete tapped") }
            )
            
            // AI suggested item
            ShoppingCard(
                image: Image(mockItem.imageName ?? "default"),
                title: "Fresh Basil",
                quantity: 1,
                isAISuggested: true,
                onDelete: { print("Delete tapped") }
            )
        }
    }
}
