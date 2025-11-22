//
//  Header.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//  Modified by Neth Botheju on 22/11/2025.
//
import SwiftUI

// MARK: - Simple Reusable Header
struct AppHeader: View {
    let leading: AnyView?
    let center: AnyView?
    let trailing: AnyView?
    let padding: EdgeInsets
    
    init(
        padding: EdgeInsets = EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24),
        @ViewBuilder leading: () -> some View = { EmptyView() },
        @ViewBuilder center: () -> some View = { EmptyView() },
        @ViewBuilder trailing: () -> some View = { EmptyView() }
    ) {
        self.leading = AnyView(leading())
        self.center = AnyView(center())
        self.trailing = AnyView(trailing())
        self.padding = padding
    }
    
    var body: some View {
        HStack {
            if let leading = leading {
                leading
            }
            
            Spacer()
            
            if let center = center {
                center
            }
            
            Spacer()
            
            if let trailing = trailing {
                trailing
            }
        }
        .padding(padding)
    }
}

// MARK: - Usage Examples
/*
 
 SIMPLE USAGE
 ============
 
 // Custom header
 AppHeader(
     leading: { Text("Title") },
     trailing: { Button("Done") {} }
 )
 
 // With back button
 AppHeader(
     leading: { BackButton(action: { dismiss() }) },
     trailing: { IconButton(icon: "heart", action: {}) }
 )
 
 // Center title
 AppHeader(
     center: { Text("Recipe Details").font(.headline) }
 )
 
 // All three sections
 AppHeader(
     leading: { BackButton(action: {}) },
     center: { Text("Title") },
     trailing: { IconButton(icon: "ellipsis", action: {}) }
 )
 
 // Existing headers still work:
 HomeHeader()
 Header(text: "Your Stock")
 
 */
