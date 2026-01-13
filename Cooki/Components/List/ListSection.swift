//
//  ListSection.swift
//  Cooki
//
//  Created by Neth Botheju on 11/1/2026.
//
import SwiftUI

// MARK: - Model
struct ListItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let iconName: String
    let iconColor: Color

    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Section Model
struct ListSection: Identifiable {
    let id = UUID()
    let items: [ListItem]
}

// MARK: - Settings Row Component
struct ListRow: View {
    let item: ListItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.iconName)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(item.iconColor)
                .cornerRadius(8)
            
            Text(item.title)
                .font(.body)
                .foregroundStyle(Color.textBlack)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.white)
    }
}
