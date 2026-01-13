//
//  FirebaseJoinRequestService.swift
//  Cooki
//
//  Updated by Rohit Valanki
//

import Foundation
import FirebaseFirestore

// MARK: - Errors
enum JoinRequestError: Error {
    case pantryNotFound
    case requestNotFound
    case alreadyMember
    case unknown
}

// MARK: - Service
final class FirebaseJoinRequestService {

    private let db = Firestore.firestore()
    private var joinRequestsListener: ListenerRegistration?

    // MARK: - Create Join Request
    func createJoinRequest(
        joinToken: String,
        requestingUserId: String,
        requestingUserName: String,
        requestingUserEmail: String? = nil
    ) async throws -> JoinRequest {

        let snapshot = try await db.collection("pantries")
            .whereField("joinToken", isEqualTo: joinToken)
            .getDocuments(source: .server)

        guard let pantryDoc = snapshot.documents.first else {
            throw JoinRequestError.pantryNotFound
        }

        let data = pantryDoc.data()

        // ✅ Prevent user already in pantry
        let memberIds = data["memberIds"] as? [String] ?? []
        if memberIds.contains(requestingUserId) {
            throw JoinRequestError.alreadyMember
        }

        // ✅ Prevent duplicate pending request
        let joinRequests = data["joinRequests"] as? [[String: Any]] ?? []
        let hasPending = joinRequests.contains {
            ($0["status"] as? String) == "pending"
            && ($0["requestingUserId"] as? String) == requestingUserId
        }

        if hasPending {
            throw JoinRequestError.unknown
        }

        let requestId = UUID()
        let now = Date()

        let joinRequestData: [String: Any] = [
            "id": requestId.uuidString,
            "requestingUserId": requestingUserId,
            "requestingUserName": requestingUserName,
            "requestingUserEmail": requestingUserEmail ?? "",
            "status": "pending",
            "createdAt": Timestamp(date: now)
        ]

        try await pantryDoc.reference.updateData([
            "joinRequests": FieldValue.arrayUnion([joinRequestData])
        ])

        return JoinRequest(
            id: requestId,
            requestingUserId: requestingUserId,
            requestingUserName: requestingUserName,
            requestingUserEmail: requestingUserEmail,
            status: .pending,
            createdAt: now
        )
    }

    // MARK: - Approve Join Request
    func approveJoinRequest(
        pantryId: String,
        joinRequestId: String
    ) async throws {

        let pantryRef = db.collection("pantries").document(pantryId)
        let snapshot = try await pantryRef.getDocument()

        guard let data = snapshot.data(),
              var joinRequests = data["joinRequests"] as? [[String: Any]],
              let index = joinRequests.firstIndex(where: { ($0["id"] as? String) == joinRequestId })
        else {
            throw JoinRequestError.requestNotFound
        }

        let pantryName = data["name"] as? String ?? "your pantry"

        var request = joinRequests[index]
        request["status"] = "approved"
        joinRequests[index] = request

        let userId = request["requestingUserId"] as? String ?? ""

        try await pantryRef.updateData([
            "joinRequests": joinRequests,
            "memberIds": FieldValue.arrayUnion([userId])
        ])

        try await addPantryToUser(pantryId: pantryId, userId: userId)

        // ✅ Publish user-level event
        try await pushUserEvent(
            userId: userId,
            title: "Join Request Approved",
            message: "Join request to \(pantryName) approved!",
            type: .joinRequestAccepted
        )

        // ✅ Publish pantry-level event
        try await pushPantryEvent(
            pantryId: pantryId,
            title: "New Member Added",
            message: "\(request["requestingUserName"] as? String ?? "Someone") has joined \(pantryName)!",
            type: .newMember
        )
    }

    // MARK: - Reject Join Request
    func rejectJoinRequest(
        pantryId: String,
        joinRequestId: String
    ) async throws {

        let pantryRef = db.collection("pantries").document(pantryId)
        let snapshot = try await pantryRef.getDocument()

        guard let data = snapshot.data(),
              var joinRequests = data["joinRequests"] as? [[String: Any]],
              let index = joinRequests.firstIndex(where: { ($0["id"] as? String) == joinRequestId })
        else {
            throw JoinRequestError.requestNotFound
        }

        let pantryName = data["name"] as? String ?? "your pantry"

        joinRequests[index]["status"] = "rejected"

        try await pantryRef.updateData([
            "joinRequests": joinRequests
        ])

        let requestingUserId = joinRequests[index]["requestingUserId"] as? String ?? ""

        // ✅ Publish user-level event
        try await pushUserEvent(
            userId: requestingUserId,
            title: "Join Request Denied",
            message: "Join request to \(pantryName) rejected",
            type: .joinRequestDenied
        )
    }

    // MARK: - Private Helpers

    private func addPantryToUser(
        pantryId: String,
        userId: String
    ) async throws {
        let userRef = db.collection("users").document(userId)
        try await userRef.updateData([
            "pantryIds": FieldValue.arrayUnion([pantryId])
        ])
    }

    private func pushUserEvent(
        userId: String,
        title: String,
        message: String,
        type: EventType,
        priority: Int = 0,
        actionIdentifier: String? = nil,
        actionPayload: [String: String]? = nil
    ) async throws {

        let event = Event(
            id: UUID().uuidString,
            title: title,
            message: message,
            priority: priority,
            timestamp: Date(),
            readBy: [],
            type: type,
            actionIdentifier: actionIdentifier,
            actionPayload: actionPayload
        )

        var data: [String: Any] = [
            "id": event.id,
            "title": event.title,
            "message": event.message,
            "priority": event.priority,
            "timestamp": Timestamp(date: event.timestamp),
            "readBy": event.readBy,
            "type": event.type.rawValue
        ]

        if let actionId = event.actionIdentifier { data["actionIdentifier"] = actionId }
        if let actionPayload = event.actionPayload { data["actionPayload"] = actionPayload }

        let userEventsRef = db.collection("users")
            .document(userId)
            .collection("events")
            .document(event.id)

        try await userEventsRef.setData(data)
    }

    // ✅ New: Push pantry-level event
    private func pushPantryEvent(
        pantryId: String,
        title: String,
        message: String,
        type: EventType,
        priority: Int = 0,
        actionIdentifier: String? = nil,
        actionPayload: [String: String]? = nil
    ) async throws {

        let event = Event(
            id: UUID().uuidString,
            title: title,
            message: message,
            priority: priority,
            timestamp: Date(),
            readBy: [],
            type: type,
            actionIdentifier: actionIdentifier,
            actionPayload: actionPayload
        )

        var data: [String: Any] = [
            "id": event.id,
            "title": event.title,
            "message": event.message,
            "priority": event.priority,
            "timestamp": Timestamp(date: event.timestamp),
            "readBy": event.readBy,
            "type": event.type.rawValue
        ]

        if let actionId = event.actionIdentifier { data["actionIdentifier"] = actionId }
        if let actionPayload = event.actionPayload { data["actionPayload"] = actionPayload }

        let pantryEventsRef = db.collection("pantries")
            .document(pantryId)
            .collection("events")
            .document(event.id)

        try await pantryEventsRef.setData(data)
    }
}

// MARK: - Real-time Listener Extension
extension FirebaseJoinRequestService {

    func listenForPendingJoinRequestsByPantryId(
        pantryId: String,
        onUpdate: @escaping ([JoinRequest]) -> Void
    ) {
        joinRequestsListener?.remove()

        joinRequestsListener = db.collection("pantries")
            .document(pantryId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Pantry join request listener error:", error.localizedDescription)
                    onUpdate([])
                    return
                }

                guard let pantryDoc = snapshot else {
                    onUpdate([])
                    return
                }

                let data = pantryDoc.data() ?? [:]
                let joinRequests = data["joinRequests"] as? [[String: Any]] ?? []

                let pending = joinRequests.compactMap { dict -> JoinRequest? in
                    guard
                        let idStr = dict["id"] as? String,
                        let id = UUID(uuidString: idStr),
                        let userId = dict["requestingUserId"] as? String,
                        let name = dict["requestingUserName"] as? String,
                        let statusStr = dict["status"] as? String,
                        let status = JoinRequest.Status(rawValue: statusStr),
                        let createdAt = dict["createdAt"] as? Timestamp
                    else { return nil }

                    return JoinRequest(
                        id: id,
                        requestingUserId: userId,
                        requestingUserName: name,
                        requestingUserEmail: dict["requestingUserEmail"] as? String,
                        status: status,
                        createdAt: createdAt.dateValue(),
                        respondedAt: (dict["respondedAt"] as? Timestamp)?.dateValue(),
                        respondedBy: dict["respondedBy"] as? String
                    )
                }.filter { $0.isPending }

                onUpdate(pending)
            }
    }

    func stopListeningForJoinRequests() {
        joinRequestsListener?.remove()
        joinRequestsListener = nil
    }
}
