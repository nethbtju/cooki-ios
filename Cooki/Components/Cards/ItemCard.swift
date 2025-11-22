//
//  ItemCard.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

/// Reusable card for displaying items with image, title, and metadata
struct ItemCard: View {
    let image: Image
    let title: String
    let quantityText: String?
    let statusBadge: StatusBadgeConfiguration?
    let showDeleteButton: Bool
    let width: CGFloat?
    let onTap: (() -> Void)?
    let onDelete: (() -> Void)?
    
    init(
        image: Image,
        title: String,
        quantityText: String? = nil,
        statusBadge: StatusBadgeConfiguration? = nil,
        showDeleteButton: Bool = false,
        width: CGFloat? = nil,
        onTap: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.image = image
        self.title = title
        self.quantityText = quantityText
        self.statusBadge = statusBadge
        self.showDeleteButton = showDeleteButton
        self.width = width
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    private var cardWidth: CGFloat {
        width ?? CardLayout.gridCardWidth()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Image container
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: cardWidth * 0.45)
                    
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: cardWidth * 0.55)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 20)
                
                // Title
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(10 / 12)
                    .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                
                // Quantity (if provided)
                if let quantityText = quantityText {
                    Text("Qty: \(quantityText)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(width: cardWidth, height: cardWidth * CardLayout.AspectRatio.portrait.value)
            .cardStyle()
            .contentShape(Rectangle())
            .onTapGesture {
                onTap?()
            }
            
            // Status badge (top-right)
            if let statusBadge = statusBadge {
                StatusBadge(configuration: statusBadge)
                    .offset(x: -10, y: 6)
            }
            
            // Delete button (top-right)
            if showDeleteButton, let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.accentBurntOrange)
                        .frame(width: 20, height: 20)
                        .background(Color.backgroundWhite.opacity(0.9))
                        .clipShape(Circle())
                }
                .offset(x: -6, y: 6)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Convenience Initializers
extension ItemCard {
    /// Create a pantry item card from PantryItem model
    static func pantryItem(_ item: Item, onTap: (() -> Void)? = nil) -> ItemCard {
        let image: Image = {
            if let imageName = item.imageName {
                return Image(imageName)
            } else {
                return Image(systemName: "photo")
            }
        }()
        
        return ItemCard(
            image: image,
            title: item.title,
            quantityText: item.quantity.displayString,
            statusBadge: .expiryStatus(daysLeft: item.daysUntilExpiry),
            onTap: onTap
        )
    }
    
    /// Create a scanned item card with delete button
    static func scannedItem(_ item: Item, onDelete: @escaping () -> Void) -> ItemCard {
        let image: Image = {
            if let imageName = item.imageName {
                return Image(imageName)
            } else {
                return Image(systemName: "photo")
            }
        }()
        
        return ItemCard(
            image: image,
            title: item.title,
            quantityText: item.quantity.displayString,
            showDeleteButton: true,
            width: 100,
            onDelete: onDelete
        )
    }
}

// MARK: - Preview
struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Pantry item
            ItemCard.pantryItem(Item.mockItem)
            
            // Scanned item with delete
            ItemCard.scannedItem(Item.mockItems[1]) {
                print("Delete tapped")
            }
            
            // Custom card
            ItemCard(
                image: Image("Bananas"),
                title: "Fresh Bananas",
                quantityText: "7 pcs",
                statusBadge: .expiryStatus(daysLeft: 2)
            )
        }
        .padding()
    }
}
