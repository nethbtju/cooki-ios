//
//  LogoHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import SwiftUI

struct LogoHeader: View {
    @Environment(\.dismiss) var dismiss
    var enableBackButton: Bool = true
    var body: some View {
        AppHeader(
            padding: EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20),
            leading: {
                VStack(alignment: .leading) {
                    BackButton(action: { dismiss() })
                    Image("AppIconMini")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                }
            }
        )
    }
}


struct LogoHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LogoHeader()
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
        }.background(.blue)
    }
}


