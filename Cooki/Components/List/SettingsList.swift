//
//  SettingsNavigation.swift
//  Cooki
//
//  Created by Neth Botheju on 11/1/2026.
//

import SwiftUI

// MARK: - Settings Destination Enum
enum SettingsDestination: Hashable {
    case accountIdentity
    case foodCooking
    case sharedPantry
    case insights
    case notifications
    case accessibility
    case support
    case privacy
}

// MARK: - Updated Settings List
struct SettingsList: View {
    var buttonAction: () -> Void

    var body: some View {
        List {
            ForEach(settingsSections) { section in
                Section {
                    ForEach(section.items) { item in
                        NavigationLink(value: item.destination) {
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
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Destination View Builder
@ViewBuilder
func settingsDestinationView(for destination: SettingsDestination) -> some View {
    switch destination {
    case .accountIdentity:
        AccountIdentityView()
    case .foodCooking:
        FoodCookingView()
    case .sharedPantry:
        SharedPantryView()
    case .insights:
        InsightsView()
    case .notifications:
        NotificationsView()
    case .accessibility:
        AccessibilityView()
    case .support:
        SupportView()
    case .privacy:
        PrivacyView()
    }
}

// MARK: - Settings Data
private let settingsSections: [ListSection] = [
    ListSection(items: [
        ListItem(
            title: "Account & Identity",
            subtitle: "Profile, sign-in details, and preferences",
            iconName: "person.circle.fill",
            iconColor: .blue,
            destination: .accountIdentity
        ),
        ListItem(
            title: "Food & Cooking",
            subtitle: "Diet, recipes, and cooking habits",
            iconName: "fork.knife",
            iconColor: .orange,
            destination: .foodCooking
        ),
        ListItem(
            title: "Shared Pantry Controls",
            subtitle: "Manage shared items and permissions",
            iconName: "square.grid.2x2.fill",
            iconColor: .blue,
            destination: .sharedPantry
        )
    ]),
    ListSection(items: [
        ListItem(
            title: "Insights & Feedback",
            subtitle: "Usage trends and app improvements",
            iconName: "chart.bar.fill",
            iconColor: .blue,
            destination: .insights
        ),
        ListItem(
            title: "Notifications",
            subtitle: "Alerts, reminders, and updates",
            iconName: "bell.fill",
            iconColor: .gray,
            destination: .notifications
        ),
        ListItem(
            title: "Accessibility & Comfort",
            subtitle: "Text size, motion, and visual options",
            iconName: "accessibility",
            iconColor: .green,
            destination: .accessibility
        ),
        ListItem(
            title: "Support & Transparency",
            subtitle: "Help, contact, and app policies",
            iconName: "questionmark.circle.fill",
            iconColor: .purple,
            destination: .support
        ),
        ListItem(
            title: "Privacy & Security",
            subtitle: "Data, permissions, and protection",
            iconName: "lock.fill",
            iconColor: .yellow,
            destination: .privacy
        )
    ])
]

// MARK: - Individual Settings Views (Templates)

struct AccountIdentityView: View {
    var body: some View {
        Form {
            Section("Profile") {
                Text("Name")
                Text("Email")
            }
            
            Section("Preferences") {
                Toggle("Show profile picture", isOn: .constant(true))
            }
        }
        .navigationTitle("Account & Identity")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FoodCookingView: View {
    var body: some View {
        Form {
            Section("Dietary Preferences") {
                Text("Vegetarian")
                Text("Allergies")
            }
        }
        .navigationTitle("Food & Cooking")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SharedPantryView: View {
    var body: some View {
        Form {
            Section("Sharing") {
                Text("Shared with: 3 people")
            }
        }
        .navigationTitle("Shared Pantry Controls")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InsightsView: View {
    var body: some View {
        Form {
            Section("Usage") {
                Text("Weekly summary")
            }
        }
        .navigationTitle("Insights & Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsView: View {
    var body: some View {
        Form {
            Section("Alerts") {
                Toggle("Push notifications", isOn: .constant(true))
                Toggle("Expiration reminders", isOn: .constant(true))
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccessibilityView: View {
    var body: some View {
        Form {
            Section("Display") {
                Text("Text size")
                Toggle("Reduce motion", isOn: .constant(false))
            }
        }
        .navigationTitle("Accessibility & Comfort")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupportView: View {
    var body: some View {
        Form {
            Section("Help") {
                Text("FAQ")
                Text("Contact us")
            }
        }
        .navigationTitle("Support & Transparency")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyView: View {
    var body: some View {
        Form {
            Section("Data") {
                Text("Privacy policy")
                Text("Data usage")
            }
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsList(buttonAction: { print("log out") })
    }
}
