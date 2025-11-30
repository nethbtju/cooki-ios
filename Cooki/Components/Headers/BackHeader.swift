//
//  BackHeader.swift
//  Cooki
//
//  Modified by Neth Botheju on 29/11/2025.
//

import SwiftUI

struct BackHeader: View {
    var action: (() -> Void)? = nil
    var body: some View {
        AppHeader(
            padding: EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20),
            leading: {
                BackButton(action: action)
            }
        )
    }
}

// MARK: - Preview
struct BackHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Default dismiss behavior
            BackHeader()
            
            Spacer()
            
            // Custom action
            BackHeader(action: {
                print("Custom back action")
            })
        }
    }
}
