//
//  HomeView.swift
//  Cooki
//
//  Created by Neth Botheju on 13/9/2025.
//  Updated by Rohit Valanki on 13/01/2026
//

import SwiftUI

struct HomeView: View {

    // MARK: - Notification Manager
    @StateObject private var notificationManager = NotificationManager.shared

    // MARK: - Join Request ViewModel
    @StateObject private var joinRequestVM = PantryJoinRequestsViewModel()

    // MARK: - Notification bookkeeping (NEW – notification only)
    @State private var lastPendingJoinRequestIds: Set<UUID> = []

    // MARK: - Mock Data
    let recipes = Recipe.mockRecipes
    let suggestions = MockData.suggestions
    let pantryItems = MockData.pantryItems

    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)

            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Notification Banner
                if let bannerData = notificationManager.currentBanner {
                    NotificationBanner(
                        showBanner: Binding(
                            get: { true },
                            set: { _ in notificationManager.bannerDidDismiss() }
                        ),
                        text: bannerData.text,
                        type: bannerData.type
                    )
                    .padding(.top, 24)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                }

                ScrollView(.vertical, showsIndicators: false) {

                    // MARK: - Your Stock Section
                    VStack(alignment: .center) {
                        Text("Your Stock")
                            .font(AppFonts.heading())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textBlack)

                        Text("Your pantry at a glance")
                            .font(AppFonts.smallBody())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textGrey2)
                            .padding(.bottom, 6)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(pantryItems, id: \.title) { pantryItem in
                                    ItemCard.pantryItem(pantryItem)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.top, 16)

                    // MARK: - Meal Plan Section
                    VStack(alignment: .center) {
                        Text("Let's cook")
                            .font(AppFonts.heading())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textBlack)

                        Text("Get started on your meal plan")
                            .font(AppFonts.smallBody())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textGrey2)
                            .padding(.bottom, 6)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // TODO: Add meal plan suggestions
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }

                    // MARK: - Meal Suggestions Section
                    VStack(alignment: .center) {
                        Text("Meal suggestions")
                            .font(AppFonts.heading())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textBlack)

                        Text("Tailored for you to eat your best")
                            .font(AppFonts.smallBody())
                            .lineLimit(1)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .foregroundStyle(Color.textGrey2)
                            .padding(.bottom, 6)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(suggestions) { suggestion in
                                    RecipeCard.suggestion(
                                        recipeSuggestion: suggestion,
                                        action: { print("Tapped suggestion") }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }

                    Spacer().frame(height: 150)
                }
            }
            .animation(
                .spring(response: 0.4, dampingFraction: 0.8),
                value: notificationManager.currentBanner
            )
        }
        .environmentObject(notificationManager)

        // MARK: - Listeners
        .onAppear {
            joinRequestVM.startListeningForCurrentPantry()
            UserEventService.shared.startListeningForCurrentUser()

            if let pantryId = CurrentUser.shared.currentPantryId {
                PantryEventService.shared.startListening(forPantryId: pantryId)
            }
        }
        .onDisappear {
            joinRequestVM.stopListening()
            UserEventService.shared.stopListening()
            PantryEventService.shared.stopListening()
        }

        // MARK: - Handle pantry switch
        .onChange(of: CurrentUser.shared.currentPantryId) { newPantryId in
            PantryEventService.shared.stopListening()
            lastPendingJoinRequestIds = []

            if let pantryId = newPantryId {
                PantryEventService.shared.startListening(forPantryId: pantryId)
            }
        }

        // MARK: - Handle Join Requests (FIXED: diff-based)
        .onChange(of: joinRequestVM.pendingRequests) { requests in
            let currentIds = Set(requests.map(\.id))
            let newIds = currentIds.subtracting(lastPendingJoinRequestIds)

            for request in requests where newIds.contains(request.id) {
                notificationManager.showJoinRequest(request) {
                    Task { await handleJoinRequest(request, approve: true) }
                } rejectAction: {
                    Task { await handleJoinRequest(request, approve: false) }
                }
            }

            lastPendingJoinRequestIds = currentIds
        }

        // MARK: - Handle Pantry Events
        .onChange(of: PantryEventService.shared.unreadEvents) { events in
            for event in events {
                let bannerType: NotificationType
                switch event.type {
                case .joinRequestCreated, .joinRequestAccepted:
                    bannerType = .success
                case .joinRequestFailed, .joinRequestDenied:
                    bannerType = .error
                default:
                    bannerType = .info
                }

                notificationManager.showBanner(
                    text: event.message,
                    type: bannerType
                )

                PantryEventService.shared.markEventAsRead(event)
            }
        }
    }

    // MARK: - Handle Join Request
    private func handleJoinRequest(_ request: JoinRequest, approve: Bool) async {
        guard let pantryId = CurrentUser.shared.currentPantryId else { return }
        let service = FirebaseJoinRequestService()
        let bannerId = "join-request-\(request.id.uuidString)"

        do {
            if approve {
                try await service.approveJoinRequest(
                    pantryId: pantryId,
                    joinRequestId: request.id.uuidString
                )
                print("✅ Approved join request for \(request.requestingUserName)")
            } else {
                try await service.rejectJoinRequest(
                    pantryId: pantryId,
                    joinRequestId: request.id.uuidString
                )
                print("❌ Declined join request for \(request.requestingUserName)")
            }

            // ✅ Remove decision banner immediately
            NotificationManager.shared.removeBanner(withId: bannerId)

        } catch {
            print("⚠️ Failed to \(approve ? "approve" : "decline") join request:", error)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
