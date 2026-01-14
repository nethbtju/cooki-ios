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
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let destination: SettingsDestination

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
        HStack(spacing: 12) {
            Image(systemName: item.iconName)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(item.iconColor)
                .cornerRadius(8)
                .font(.system(size: 20))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body)
                    .foregroundColor(.primary)

                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .opacity(0.85)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 6)
    }
}
