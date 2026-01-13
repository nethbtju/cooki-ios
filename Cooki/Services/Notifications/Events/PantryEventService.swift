//
//  PantryEventService.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/01/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
final class PantryEventService: ObservableObject {

    static let shared = PantryEventService()

    private let db = Firestore.firestore()
    private var eventsListener: ListenerRegistration?

    @Published var unreadEvents: [Event] = []

    private init() {}

    // MARK: - Start listening for events for a pantry
    func startListening(forPantryId pantryId: String) {
        listenForPantryEvents(pantryId: pantryId)
    }

    // MARK: - Stop listening
    func stopListening() {
        eventsListener?.remove()
        eventsListener = nil
        unreadEvents = []
    }

    // MARK: - Private listener
    private func listenForPantryEvents(pantryId: String) {
        eventsListener?.remove()

        eventsListener = db.collection("pantries")
            .document(pantryId)
            .collection("events")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error listening for pantry events:", error.localizedDescription)
                    self.unreadEvents = []
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.unreadEvents = []
                    return
                }

                let events: [Event] = documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let id = data["id"] as? String,
                        let title = data["title"] as? String,
                        let message = data["message"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp,
                        let typeRaw = data["type"] as? String,
                        let type = EventType(rawValue: typeRaw),
                        let priority = data["priority"] as? Int,
                        let readBy = data["readBy"] as? [String]
                    else { return nil }

                    let actionIdentifier = data["actionIdentifier"] as? String
                    let actionPayload = data["actionPayload"] as? [String: String]

                    return Event(
                        id: id,
                        title: title,
                        message: message,
                        priority: priority,
                        timestamp: timestamp.dateValue(),
                        readBy: readBy,
                        type: type,
                        actionIdentifier: actionIdentifier,
                        actionPayload: actionPayload
                    )
                }

                // Filter unread events for current user
                guard let currentUserId = CurrentUser.shared.user?.id else {
                    self.unreadEvents = []
                    return
                }

                let newUnread = events.filter { !$0.isRead(by: currentUserId) }
                self.unreadEvents = newUnread
            }
    }

    // MARK: - Mark event as read (called from HomeView)
    func markEventAsRead(_ event: Event) {
        guard let pantryId = CurrentUser.shared.currentPantryId,
              let currentUserId = CurrentUser.shared.user?.id else { return }

        let eventRef = db.collection("pantries")
            .document(pantryId)
            .collection("events")
            .document(event.id)

        eventRef.updateData([
            "readBy": FieldValue.arrayUnion([currentUserId])
        ]) { error in
            if let error = error {
                print("❌ Failed to mark pantry event as read:", error.localizedDescription)
            }
        }
    }
}
