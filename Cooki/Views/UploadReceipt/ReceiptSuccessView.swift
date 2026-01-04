//
//  ReceiptSuccessView.swift
//  Cooki
//

import SwiftUI

struct ReceiptSuccessView: View {
    @State var items: [Item]
    var onAddItems: () -> Void = {}

    @StateObject private var pantryVM = PantryViewModel()
    @State private var isAddingItems = false  // Add loading state
    
    var body: some View {
        VStack(spacing: 0) {
            BackHeader()
            
            ReceiptContentCard(
                items: $items,
                onAddItems: addItemsToPantry,
                isAddingItems: $isAddingItems  // Pass loading state
            )
        }
        .background {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .offset(x: -50, y: -50)
                .ignoresSafeArea()
        }
        .background(Color.secondaryPurple)
        .navigationBarHidden(true)
        .onAppear {
            printItems()
        }
    }
    
    // MARK: - Add items to Firebase pantry
    private func addItemsToPantry() {
        guard !isAddingItems else { return }  // Prevent double-tap
        
        isAddingItems = true
        
        Task {
            guard !items.isEmpty else {
                isAddingItems = false
                return
            }
            
            let itemService = FirebaseItemService()
            let pantryService = FirebasePantryService()
            
            for item in items {
                do {
                    try await itemService.addItemToCurrentPantry(item, pantryService: pantryService)
                    print("✅ Added \(item.title) to pantry")
                } catch {
                    print("❌ Failed to add \(item.title): \(error.localizedDescription)")
                }
            }
            
            await pantryVM.fetchCurrentPantryItems()
            
            // Don't reset isAddingItems here - let navigation happen
            onAddItems()
        }
    }
    
    // MARK: - Debug: Print items
    private func printItems() {
        guard !items.isEmpty else {
            print("🧾 No items to display")
            return
        }
        
        print("🧾 Scanned Items (\(items.count)):")
        for item in items {
            print("- \(item.title) | Quantity: \(item.quantity.value) \(item.quantity.unit) | Location: \(item.location) | Category: \(item.category)")
        }
    }
}

// MARK: - Preview
struct ReceiptSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReceiptSuccessView(items: MockData.pantryItems)
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
        }
    }
}

// MARK: - Receipt Content Card
struct ReceiptContentCard: View {
    @Binding var items: [Item]
    var onAddItems: () -> Void = {}
    @Binding var isAddingItems: Bool  // Add binding for loading state

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Spacer().frame(height: 40)
                    
                    Text("Receipt successfully read!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.text)
                    
                    Text("Cooki will add these items to your pantry")
                        .font(.system(size: 12))
                        .foregroundColor(.textGreyDark)
                }
                .padding(.bottom, 24)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(items) { item in
                            let deleteAction = {
                                withAnimation {
                                    items.removeAll { $0.id == item.id }
                                }
                            }

                            ItemCard.scannedItem(item, onDelete: deleteAction)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                
                PrimaryButton(
                    title: isAddingItems ? "Adding Items..." : "Add Items",
                    action: onAddItems
                )
                .disabled(isAddingItems)  // Disable when adding
                .opacity(isAddingItems ? 0.6 : 1.0)  // Visual feedback
                .padding(.horizontal, 15)
                .padding(.bottom, 28)
            }
            .background(Color.white)
            .mask {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.white)
                        ScallopedEdgeMask()
                            .fill(Color.white)
                            .frame(height: 20)
                            .rotationEffect(.degrees(180))
                    }
                }
            }
            .clipShape(TopRoundedModal())
            .padding(.horizontal, 20)
            .padding(.top, 35)
            
            ZStack {
                Circle().fill(Color.white).frame(width: 85, height: 85)
                Circle().fill(Color.green.opacity(0.2)).frame(width: 50, height: 50)
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.green)
            }
            .offset(y: -3)
        }
    }
}

// MARK: - Scalloped Edge Mask
struct ScallopedEdgeMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let circleRadius: CGFloat = 11
        let circleDiameter = circleRadius * 2
        let spacing: CGFloat = 8
        
        let totalWidth = circleDiameter + spacing
        let circleCount = Int(rect.width / totalWidth)
        let totalUsedWidth = CGFloat(circleCount) * circleDiameter + CGFloat(circleCount - 1) * spacing
        let sideMargin = (rect.width - totalUsedWidth) / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: sideMargin, y: 0))
        
        for i in 0..<circleCount {
            let centerX = sideMargin + CGFloat(i) * totalWidth + circleRadius
            path.addArc(
                center: CGPoint(x: centerX, y: 0),
                radius: circleRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: true
            )
            
            if i < circleCount - 1 {
                path.addLine(to: CGPoint(x: centerX + circleRadius + spacing, y: 0))
            }
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
