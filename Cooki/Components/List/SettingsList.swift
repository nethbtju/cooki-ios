//
//  SettingsList.swift
//  Cooki
//
//  Created by Neth Botheju on 11/1/2026.
//
import SwiftUI

struct SettingsList: View {
    var buttonAction: () -> Void
    
    private let settingsSections: [ListSection] = [
        ListSection(items: [
            ListItem(title: "Account & Identity", iconName: "person.circle.fill", iconColor: .blue),
            ListItem(title: "Food & Cooking", iconName: "fork.knife", iconColor: .orange),
            ListItem(title: "Shared Pantry Controls", iconName: "square.grid.2x2.fill", iconColor: .blue)
        ]),
        ListSection(items: [
            ListItem(title: "Insights & Feedback", iconName: "chart.bar.fill", iconColor: .blue),
            ListItem(title: "Notifications", iconName: "bell.fill", iconColor: .gray),
            ListItem(title: "Accessibility & Comfort", iconName: "accessibility", iconColor: .green),
            ListItem(title: "Support & Transparency", iconName: "questionmark.circle.fill", iconColor: .purple),
            ListItem(title: "Privacy & Security", iconName: "lock.fill", iconColor: .yellow)
        ])
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(settingsSections) { section in
                    Section {
                        ForEach(section.items) { item in
                            NavigationLink(value: item) {
                                ListRow(item: item)
                            }
                        }
                    }
                }
                
                Section {
                    PrimaryButton.primary(
                        title: "Log out",
                        action: buttonAction,
                        isEnabled: true
                    )
                    .listRowInsets(EdgeInsets()) // make button full-width
                }
            }
            .listStyle(.insetGrouped)
            .navigationDestination(for: ListItem.self) { item in
                Text(item.title)
                    .navigationTitle(item.title)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Preview
#Preview {
    SettingsList(buttonAction: { print("mao") })
}
