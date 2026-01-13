//
//  UserEventService.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/1/2026.
//


//
//  UserEventService.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/01/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
final class UserEventService: ObservableObject {
    
    static let shared = UserEventService()
    
    private let db = Firestore.firestore()
    private var eventsListener: ListenerRegistration?
    
    @Published var unreadEvents: [Event] = []
    
    private init() {}
    
    // MARK: - Start listening for events of current user
    func startListeningForCurrentUser() {
        guard let userId = CurrentUser.shared.user?.id else {
            print("⚠️ No current user id to listen for events")
            return
        }
        listenForUserEvents(userId: userId)
    }
    
    // MARK: - Stop listening
    func stopListening() {
        eventsListener?.remove()
        eventsListener = nil
    }
    
    // MARK: - Private listener
    private func listenForUserEvents(userId: String) {
        eventsListener?.remove()
        
        eventsListener = db.collection("users")
            .document(userId)
            .collection("events")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error listening for user events:", error.localizedDescription)
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
                let newUnread = events.filter { !$0.isRead(by: userId) }
                self.unreadEvents = newUnread
                
                // Push all unread events to NotificationManager as banners
                self.pushEventsToNotifications(newUnread)
            }
    }
    
    // MARK: - Push unread events to NotificationManager
    private func pushEventsToNotifications(_ events: [Event]) {
        for event in events {
            guard let userId = CurrentUser.shared.user?.id else { continue }
            
            // Determine NotificationType
            let bannerType: NotificationType
            switch event.type {
            case .joinRequestCreated, .joinRequestAccepted:
                bannerType = .success
            case .joinRequestFailed, .joinRequestDenied:
                bannerType = .error
            default:
                continue
            }
            
            NotificationManager.shared.showBanner(
                text: event.message,
                type: bannerType
            )
            
            // Mark as read after showing
            markEventAsRead(event, for: userId)
        }
    }
    
    // MARK: - Mark event as read
    private func markEventAsRead(_ event: Event, for userId: String) {
        let eventRef = db.collection("users")
            .document(userId)
            .collection("events")
            .document(event.id)
        
        eventRef.updateData([
            "readBy": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("❌ Failed to mark event as read:", error.localizedDescription)
            }
        }
    }
}
