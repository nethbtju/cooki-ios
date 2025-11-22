//
//  TabHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

struct TabHeader: View {
    let text: String
    
    var body: some View {
        AppHeader(
            padding: EdgeInsets(top: 20, leading: 24, bottom: 10, trailing: 24),
            leading: {
                Text(text)
                    .font(AppFonts.heading3())
                    .foregroundStyle(Color.backgroundWhite)
            }
        )
    }
}
