//
//  ReceiptContentHeader.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

struct BackHeader: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        AppHeader(
            padding: EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20),
            leading: {
                BackButton(action: { dismiss() })
            }
        )
    }
}
