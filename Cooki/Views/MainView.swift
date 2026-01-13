//
//  MainView.swift
//  Cooki
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // MARK: - State
    @State private var selectedTab: Int = 0
    @State private var showAddItemSheet = false
    @State private var isLoggedOut = false
    @State private var navigationPath = NavigationPath()
    @State private var isPillsExpanded = false

    // MARK: - Join Request Alert
    @StateObject private var joinRequestVM = PantryJoinRequestsViewModel()
    @State private var pendingRequestQueue: [JoinRequest] = []
    @State private var currentRequest: JoinRequest?

    // MARK: - Join Pantry Sheet
    @State private var showJoinPantrySheet = false
    @State private var joinTokenInput = ""

    // MARK: - Computed Properties
    private var user: User {
        appViewModel.currentUser ?? User.mock
    }

    private var authService: FirebaseAuthService {
        FirebaseAuthService()
    }

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            if isLoggedOut {
                LoginView()
            } else {
                ZStack(alignment: .bottom) {
                    selectedView(selectedTab, user: user)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)

                    // MARK: - Pill Buttons Data
                    let pillData: [(icon: String, text: String, action: () -> Void)] = [
                        ("scanner", "Scan receipt", { print("Scan tapped") }),
                        ("cube.box", "Add new item", { showAddItemSheet = true }),
                        ("person.3.fill", "Join new pantry", { showJoinPantrySheet = true })
                    ]

                    CustomTabBar(selectedTab: $selectedTab, isExpanded: $isPillsExpanded, pillData: pillData)
                        .ignoresSafeArea(.keyboard)
                }
                .ignoresSafeArea(edges: .bottom)

                // MARK: - Add Pantry Item Sheet
                .sheet(isPresented: $showAddItemSheet) {
                    AddPantryItemView(onUploadReceipt: {
                        navigationPath.append("UploadReceipt")
                    })
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
                    .presentationBackground(.white)
                }

                // MARK: - Join Pantry Sheet
                .sheet(isPresented: $showJoinPantrySheet) {
                    VStack(spacing: 25) {
                        Capsule()
                            .frame(width: 40, height: 5)
                            .foregroundColor(.gray.opacity(0.4))
                            .padding(.top, 8)

                        Text("Join a Pantry")
                            .font(.title2)
                            .fontWeight(.bold)

                        TextField("Enter pantry join token", text: $joinTokenInput)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.characters)

                        HStack(spacing: 20) {
                            Button {
                                joinTokenInput = ""
                                showJoinPantrySheet = false
                            } label: {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.red)
                                    .cornerRadius(12)
                            }

                            Button {
                                Task {
                                    let token = joinTokenInput.trimmingCharacters(in: .whitespacesAndNewlines)
                                    guard !token.isEmpty else { return }
                                    await joinPantry(with: token)
                                    joinTokenInput = ""
                                    showJoinPantrySheet = false
                                }
                            } label: {
                                Text("Join")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.hidden)
                }

                // MARK: - Navigation Destination
                .navigationDestination(for: String.self) { route in
                    if route == "UploadReceipt" {
                        UploadReceiptView(onNavigateToPantry: {
                            navigationPath.removeLast(navigationPath.count)
                            selectedTab = 1
                            isPillsExpanded = false
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                }

                // MARK: - Join Request Listeners
                .onAppear {
                    joinRequestVM.startListeningForCurrentPantry()
                }
                .onChange(of: CurrentUser.shared.currentPantryId) { _ in
                    joinRequestVM.startListeningForCurrentPantry()
                }
                .onChange(of: joinRequestVM.pendingRequests) { pendingRequests in
                    let sortedRequests = pendingRequests.sorted(by: { $0.createdAt < $1.createdAt })
                    pendingRequestQueue = sortedRequests
                    showNextRequestAlert()
                }
                .alert(item: $currentRequest) { request in
                    Alert(
                        title: Text("Pending Join Request"),
                        message: Text("\(request.requestingUserName) wants to join your pantry."),
                        primaryButton: .destructive(Text("Reject")) {
                            Task { await handleJoinRequest(request, approve: false) }
                        },
                        secondaryButton: .default(Text("Approve")) {
                            Task { await handleJoinRequest(request, approve: true) }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Show Next Alert in Queue
    private func showNextRequestAlert() {
        if !pendingRequestQueue.isEmpty {
            currentRequest = pendingRequestQueue.removeFirst()
        } else {
            currentRequest = nil
        }
    }

    // MARK: - Selected Tab View
    @ViewBuilder
    private func selectedView(_ tab: Int, user: User) -> some View {
        switch tab {
        case 0:
            MainLayout(
                header: {
                    HomeHeader(user: user, authService: authService)
                        .onTapGesture { logout() }
                },
                content: {
                    HomeView(notificationText: "4 items in pantry expiring soon!")
                        .previewDevice("iPhone 15 Pro")
                        .preferredColorScheme(.light)
                }
            )
        case 1:
            MainLayout(header: { TabHeader(text: "Your Stock") },
                       content: { PantryView() })
        case 2:
            MainLayout(header: { TabHeader(text: "Your Meal Plan") },
                       content: { MealPlanView() })
        case 3:
            MainLayout(header: { TabHeader(text: "Your Shopping List") },
                       content: { ShoppingListView() })
        default:
            MainLayout(
                header: { HomeHeader(user: user, authService: authService) },
                content: { HomeView() }
            )
        }
    }

    // MARK: - Logout
    private func logout() {
        do {
            try authService.signOut()
            appViewModel.currentUser = nil
            isLoggedOut = true
            print("✅ User logged out")
        } catch {
            print("❌ Logout failed: \(error)")
        }
    }

    // MARK: - Join Pantry
    private func joinPantry(with joinToken: String) async {
        guard let currentUser = CurrentUser.shared.user else {
            print("⚠️ Current user not set")
            return
        }

        let service = FirebaseJoinRequestService()

        do {
            let request = try await service.createJoinRequest(
                joinToken: joinToken,
                requestingUserId: currentUser.id,
                requestingUserName: currentUser.displayName,
                requestingUserEmail: currentUser.email
            )
            print("✅ Join request created:", request)
        } catch JoinRequestError.alreadyMember {
            print("⚠️ User already a member")
        } catch {
            print("❌ Failed to create join request:", error)
        }
    }

    // MARK: - Handle Join Request
    private func handleJoinRequest(_ request: JoinRequest, approve: Bool) async {
        guard let currentPantryId = CurrentUser.shared.currentPantryId else {
            print("⚠️ No active pantry selected")
            showNextRequestAlert()
            return
        }

        let service = FirebaseJoinRequestService()

        do {
            if approve {
                try await service.approveJoinRequest(
                    pantryId: currentPantryId,
                    joinRequestId: request.id.uuidString
                )
                print("✅ Approved join request for \(request.requestingUserName)")
            } else {
                try await service.rejectJoinRequest(
                    pantryId: currentPantryId,
                    joinRequestId: request.id.uuidString
                )
                print("❌ Declined join request for \(request.requestingUserName)")
            }
        } catch {
            print("⚠️ Failed to \(approve ? "approve" : "decline") join request:", error)
        }

        showNextRequestAlert()
    }
}

// MARK: - Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
            .environmentObject(AppViewModel())
    }
}
