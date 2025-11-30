//
//  BasketLoadingView.swift
//  Cooki
//
//  Created by Neth Botheju on 30/11/2025.
//
import SwiftUI

struct BasketLoadingView: View {
    var body: some View {
        GeometryReader { geo in
            let bx = geo.size.width / 2
            let by = geo.size.height / 2
            
            ZStack {
                Color.white.ignoresSafeArea()
                
                // Example using Figma positions
                basketItem("Meat", itemX: 157, itemY: 333, itemWidth: 110, itemHeight: 99, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Bread", itemX: 99, itemY: 312, itemWidth: 113, itemHeight: 136, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Cucumber", itemX: 203, itemY: 352, itemWidth: 81, itemHeight: 133, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Tomato", itemX: 110, itemY: 422, itemWidth: 61, itemHeight: 62, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Tomato", itemX: 209, itemY: 353, itemWidth: 61, itemHeight: 62, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Orange", itemX: 194, itemY: 414, itemWidth: 73, itemHeight: 74, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Orange", itemX: 156, itemY: 366, itemWidth: 57, itemHeight: 58, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Capsicum", itemX: 139, itemY: 398, itemWidth: 92, itemHeight: 93, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Capsicum", itemX: 97, itemY: 352, itemWidth: 75, itemHeight: 76, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Egg", itemX: 108, itemY: 408, itemWidth: 41, itemHeight: 51, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Banana", itemX: 121, itemY: 343, itemWidth: 115, itemHeight: 116, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("Egg", itemX: 203, itemY: 366, itemWidth: 41, itemHeight: 51, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                basketItem("WaterBottle", itemX: 121, itemY: 341, itemWidth: 90, itemHeight: 140, basketWidth: 193, basketHeight: 175,
                           basketCenterX: bx, basketCenterY: by)
                
                // Basket on top
                Image("Basket")
                    .resizable()
                    .frame(width: 193, height: 175)
                    .position(x: bx, y: by)
            }
        }
    }
    
    // Helper to compute offsets from basket center using Figma coordinates
    @ViewBuilder
    func basketItem(_ name: String,
                    itemX: CGFloat, itemY: CGFloat,
                    itemWidth: CGFloat, itemHeight: CGFloat,
                    basketWidth: CGFloat, basketHeight: CGFloat,
                    basketCenterX: CGFloat, basketCenterY: CGFloat) -> some View {
        
        let basketY: CGFloat = 319
        let basketX: CGFloat = 91
        
        let itemCenterX = itemX + itemWidth / 2
        let itemCenterY = itemY + itemHeight / 2
        
        let basketCenterFX = basketX + basketWidth / 2
        let basketCenterFY = basketY + basketHeight / 2
        
        let offsetX = itemCenterX - basketCenterFX
        let offsetY = itemCenterY - basketCenterFY
        
        Image(name)
            .resizable()
            .frame(width: itemWidth, height: itemHeight)
            .position(x: basketCenterX + offsetX,
                      y: basketCenterY + offsetY)
    }
}

#Preview {
    BasketLoadingView()
}
