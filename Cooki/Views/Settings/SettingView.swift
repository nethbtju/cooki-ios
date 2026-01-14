//
//  SettingView.swift
//  Cooki
//
//  Created by Neth Botheju on 11/1/2026.
//
import SwiftUI

public struct SettingView: View {
    public var body: some View {
        MainLayout(header: { BackHeader().padding(.bottom, 60) }, content: { SettingContent()})
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden(true)
    }
}

// MARK: - User Details Content
struct SettingContent: View {
    @EnvironmentObject var appViewModel: AppViewModel

    private let avatarSize: CGFloat = 150
    private let overlap: CGFloat = 75

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Modal container
            VStack(spacing: 12) {
                // Spacer to account for avatar overlap
                Spacer()
                    .frame(height: overlap)
                
                Text("Hello, \(appViewModel.currentUser?.displayName ?? "Stranger!")").font(AppFonts.subheading()).padding(0)
                    .offset(y: 10)
                SettingsList(buttonAction: {
                    Task {
                        await appViewModel.signOut()
                    }
                })
            }
            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
            .clipShape(TopRoundedModal())
            .ignoresSafeArea(edges: .bottom)
            
            // MARK: - Floating profile icon
            ProfileIcon(
                image: appViewModel.currentUser?.getProfilePicture ?? Image("ProfilePic"), // TODO: FIX THIS
                size: avatarSize,
                editable: true
            )
            .offset(y: -overlap)
        }
    }
        
}

// MARK: - Preview
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(AppViewModel())
    }
}
