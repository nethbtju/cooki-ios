//
//  FormTextField.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import SwiftUI

struct FormTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let textContentType: UITextContentType?
    let autocapitalization: TextInputAutocapitalization
    let isSecure: Bool
    let isFocused: Bool   // ← NEW

    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .never,
        isSecure: Bool = false,
        isFocused: Bool = false   // ← NEW
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
        self.isFocused = isFocused
    }

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray.opacity(0.3))
                    }
            } else {
                TextField(placeholder, text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray.opacity(0.3))
                    }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.accentPeach : Color.textGrey, lineWidth: 1) // ← USE FOCUS
        )
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .textInputAutocapitalization(autocapitalization)
        .autocorrectionDisabled()
        .font(AppFonts.lightBody())
        .foregroundColor(Color.textGrey)
        .tint(.accentBurntOrange)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
