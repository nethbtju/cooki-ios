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
                
                // Items in original order
                basketItem("Meat", itemX: 157, itemY: 333, itemWidth: 110, itemHeight: 99,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -15, floatOffsetY: -60)
                
                basketItem("Bread", itemX: 99, itemY: 312, itemWidth: 113, itemHeight: 136,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -20, floatOffsetY: -70)
                
                basketItem("Cucumber", itemX: 203, itemY: 352, itemWidth: 81, itemHeight: 133,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 25, floatOffsetY: -65)
                
                basketItem("Tomato", itemX: 110, itemY: 422, itemWidth: 61, itemHeight: 62,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -10, floatOffsetY: -50)
                
                basketItem("Tomato", itemX: 209, itemY: 353, itemWidth: 61, itemHeight: 62,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 18, floatOffsetY: -55)
                
                basketItem("Orange", itemX: 194, itemY: 414, itemWidth: 73, itemHeight: 74,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 22, floatOffsetY: -58)
                
                basketItem("Orange", itemX: 156, itemY: 366, itemWidth: 57, itemHeight: 58,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -25, floatOffsetY: -62)
                
                basketItem("Capsicum", itemX: 139, itemY: 398, itemWidth: 92, itemHeight: 93,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 10, floatOffsetY: -68)
                
                basketItem("Capsicum", itemX: 97, itemY: 352, itemWidth: 75, itemHeight: 76,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -18, floatOffsetY: -54)
                
                basketItem("Egg", itemX: 108, itemY: 408, itemWidth: 41, itemHeight: 51,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -14, floatOffsetY: -48)
                
                basketItem("Banana", itemX: 121, itemY: 343, itemWidth: 115, itemHeight: 116,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 24, floatOffsetY: -72)
                
                basketItem("Egg", itemX: 203, itemY: 366, itemWidth: 41, itemHeight: 51,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: 20, floatOffsetY: -52)
                
                basketItem("WaterBottle", itemX: 121, itemY: 341, itemWidth: 90, itemHeight: 140,
                          basketWidth: 193, basketHeight: 175, basketCenterX: bx, basketCenterY: by,
                          floatOffsetX: -10, floatOffsetY: -75)
                
                // Basket on top
                Image("Basket")
                    .resizable()
                    .frame(width: 193, height: 175)
                    .position(x: bx, y: by)
            }
        }
    }
    
    @ViewBuilder
    func basketItem(_ name: String,
                    itemX: CGFloat, itemY: CGFloat,
                    itemWidth: CGFloat, itemHeight: CGFloat,
                    basketWidth: CGFloat, basketHeight: CGFloat,
                    basketCenterX: CGFloat, basketCenterY: CGFloat,
                    floatOffsetX: CGFloat,
                    floatOffsetY: CGFloat) -> some View {
        
        let basketY: CGFloat = 319
        let basketX: CGFloat = 91
        
        let itemCenterX = itemX + itemWidth / 2
        let itemCenterY = itemY + itemHeight / 2
        
        let basketCenterFX = basketX + basketWidth / 2
        let basketCenterFY = basketY + basketHeight / 2
        
        let offsetX = itemCenterX - basketCenterFX
        let offsetY = itemCenterY - basketCenterFY
        
        ItemView(name: name,
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                restX: basketCenterX + offsetX,
                restY: basketCenterY + offsetY,
                floatOffsetX: floatOffsetX,
                floatOffsetY: floatOffsetY)
    }
}

struct ItemView: View {
    let name: String
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let restX: CGFloat
    let restY: CGFloat
    let floatOffsetX: CGFloat
    let floatOffsetY: CGFloat
    
    @State private var isFloating = false
    @State private var shake = 0.0
    
    var body: some View {
        Image(name)
            .resizable()
            .frame(width: itemWidth, height: itemHeight)
            .rotationEffect(.degrees(shake))
            .position(
                x: restX + (isFloating ? floatOffsetX : 0),
                y: restY + (isFloating ? floatOffsetY : 0)
            )
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        // Float up
        withAnimation(.easeOut(duration: 0.4)) {
            isFloating = true
        }
        
        // Start shaking at the top
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.linear(duration: 0.08).repeatCount(6, autoreverses: true)) {
                shake = 5
            }
            
            // Fall back down
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.3)) {
                    isFloating = false
                    shake = 0
                }
                
                // Restart cycle
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    startAnimation()
                }
            }
        }
    }
}

#Preview {
    BasketLoadingView()
}
