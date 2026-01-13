//
//  NotificationManager.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/01/2026.
//

import SwiftUI
import Combine

// MARK: - Notification Data
struct NotificationBannerData: Identifiable, Equatable {
    let id: String                 // ✅ stable identity
    let text: String
    let type: NotificationType

    static func == (lhs: NotificationBannerData, rhs: NotificationBannerData) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Notification Manager
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published private(set) var queue: [NotificationBannerData] = []
    @Published var currentBanner: NotificationBannerData?

    private var isShowing = false
    private init() {}

    // MARK: - Generic banner
    func showBanner(text: String, type: NotificationType) {
        let banner = NotificationBannerData(
            id: UUID().uuidString,
            text: text,
            type: type
        )

        queue.append(banner)
        displayNextIfNeeded()
    }

    // MARK: - Join request banner (deduped)
    func showJoinRequest(
        _ request: JoinRequest,
        approveAction: @escaping () -> Void,
        rejectAction: @escaping () -> Void
    ) {
        let bannerId = "join-request-\(request.id.uuidString)"

        // ✅ Prevent duplicates
        guard !queue.contains(where: { $0.id == bannerId }) else { return }

        let banner = NotificationBannerData(
            id: bannerId,
            text: "\(request.requestingUserName) wants to join your pantry.",
            type: .decision(
                onYes: approveAction,
                onNo: rejectAction
            )
        )

        queue.append(banner)
        displayNextIfNeeded()
    }

    // MARK: - Display logic
    private func displayNextIfNeeded() {
        guard !isShowing, let next = queue.first else { return }
        isShowing = true
        currentBanner = next
    }

    func bannerDidDismiss() {
        guard !queue.isEmpty else {
            currentBanner = nil
            isShowing = false
            return
        }

        queue.removeFirst()
        currentBanner = nil
        isShowing = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.displayNextIfNeeded()
        }
    }

    // MARK: - Explicit removal (used by join requests)
    func removeBanner(withId id: String) {
        if currentBanner?.id == id {
            bannerDidDismiss()
        } else {
            queue.removeAll { $0.id == id }
        }
    }
}
