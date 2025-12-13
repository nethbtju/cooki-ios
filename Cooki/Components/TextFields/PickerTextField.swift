//
//  PickerTextField.swift
//  Cooki
//
//  Created by Neth Botheju on 23/11/2025.
//
import SwiftUI

struct PickerTextField: View {
    let placeholder: String
    let isFocused: Bool

    @Binding var selectedValue: String
    let options: [String]

    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker = true    // Open picker
        } label: {
            HStack {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .font(AppFonts.lightBody())
                    .foregroundColor(selectedValue.isEmpty ? .textGrey.opacity(0.3) : .textGrey)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(.textGrey)
                    .rotationEffect(.degrees(showPicker ? 180 : 0))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.accent : Color.textGrey, lineWidth: 1)
            )
        }
        .sheet(isPresented: $showPicker) {
            VStack(spacing: 0) {
                // Toolbar with centered title using overlay
                HStack {
                    Spacer()

                    Button("Done") {
                        showPicker = false
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 44)
                .overlay(
                    Text("Select \(placeholder.lowercased())")
                        .font(.headline)
                )

                // Wheel Picker
                Picker("", selection: $selectedValue) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
            }
            .presentationDetents([.fraction(0.35)])
        }
    }
}

struct PickerTextField_Previews: PreviewProvider {
    @State static var gender = ""

    static var previews: some View {
        VStack {
            PickerTextField(
                placeholder: "Gender",
                isFocused: true,
                selectedValue: $gender,
                options: ["Male", "Female", "Other"]
            )
        }
        .padding()
    }
}
