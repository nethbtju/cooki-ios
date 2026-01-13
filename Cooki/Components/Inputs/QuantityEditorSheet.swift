//
//  QuantityEditorSheet.swift
//  Cooki
//
//  Created by Neth Botheju on 8/1/2026.
//
import SwiftUI

// MARK: - Quantity Editor Sheet
struct QuantityEditorSheet: View {
    @Binding var quantity: Int
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State private var isEditingText = false
    @State private var textValue = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Plus/Minus controls
                HStack(spacing: 20) {
                    // Minus button
                    Button(action: decrementQuantity) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(quantity > 1 ? .accentBurntOrange : .gray.opacity(0.3))
                    }
                    .disabled(quantity <= 1)
                    
                    // Quantity display - tappable to edit
                    ZStack {
                        if isEditingText {
                            TextField("", text: $textValue)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .frame(width: 120)
                                .keyboardType(.numberPad)
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    updateQuantityFromText()
                                }
                        } else {
                            Button(action: {
                                textValue = "\(quantity)"
                                isEditingText = true
                                isTextFieldFocused = true
                            }) {
                                VStack(spacing: 4) {
                                    Text("\(quantity)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.primary)
                                        .contentTransition(.numericText())
                                    
                                    Text("Tap to edit")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 120)
                            }
                        }
                    }
                    
                    // Plus button
                    Button(action: incrementQuantity) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.accentBurntOrange)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
            }
            .navigationTitle("Edit Quantity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if isEditingText {
                            updateQuantityFromText()
                        }
                        dismiss()
                    }
                    .foregroundColor(.accentBurntOrange)
                }
            }
        }
        .onChange(of: isTextFieldFocused) { focused in
            if !focused && isEditingText {
                updateQuantityFromText()
            }
        }
    }
    
    private func incrementQuantity() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            quantity += 1
        }
    }
    
    private func decrementQuantity() {
        if quantity > 1 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                quantity -= 1
            }
        }
    }
    
    private func updateQuantityFromText() {
        if let newQuantity = Int(textValue), newQuantity >= 1 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                quantity = newQuantity
            }
        }
        isEditingText = false
        isTextFieldFocused = false
    }
}

// MARK: - Preview
struct QuantityEditorSheet_Previews: PreviewProvider {
    static var previews: some View {
        QuantityEditorSheetPreviewWrapper()
    }
}

// Preview wrapper to handle @Binding
private struct QuantityEditorSheetPreviewWrapper: View {
    @State private var quantity = 5
    
    var body: some View {
        QuantityEditorSheet(quantity: $quantity)
    }
}
