//
//  PantryJoinRequestsViewModel.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/1/2026.
//


import Foundation
import Combine

@MainActor
final class PantryJoinRequestsViewModel: ObservableObject {

    @Published var pendingRequests: [JoinRequest] = []

    private let service = FirebaseJoinRequestService()
    private var pantryId: String?

    func startListeningForCurrentPantry() {
        guard let currentPantryId = CurrentUser.shared.currentPantryId else { return }
        pantryId = currentPantryId
        service.listenForPendingJoinRequestsByPantryId(pantryId: currentPantryId) { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingRequests = requests
            }
        }
    }

    func stopListening() {
        service.stopListeningForJoinRequests()
    }
}
