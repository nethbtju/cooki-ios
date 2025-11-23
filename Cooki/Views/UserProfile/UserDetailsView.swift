//
//  UserDetailsView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//

import SwiftUI

public struct UserDetailsView: View {
    public var body: some View {
        MainLayout(header: { LogoHeader(enableBackButton: true) }, content: { UserDetailsContent() })
            .navigationBarHidden(true)
    }
}

struct UserDetailsContent: View {
    @State private var preferredName: String = ""
    @State private var selectedGender: Gender = .preferNotToSay
    @State private var selectedCountry: String = "United States"
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var useMetric: Bool = true
    @State private var selectedDietaryPreferences: Set<DietaryPreference> = []
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case preferredName, gender, country, height, weight
    }
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case nonBinary = "Non-binary"
        case preferNotToSay = "Prefer not to say"
    }
    
    // Common countries list
    let countries = [
        "United States", "Canada", "United Kingdom", "Australia", "Germany",
        "France", "Italy", "Spain", "Japan", "China", "India", "Brazil",
        "Mexico", "Netherlands", "Sweden", "Norway", "Denmark", "Finland",
        "New Zealand", "Singapore", "South Korea", "Thailand", "Vietnam"
    ].sorted()
    
    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome to your new pantry manager! 🍪")
                                .font(AppFonts.heading())
                            
                            Text("Help us personalize your experience")
                                .font(AppFonts.regularBody())
                                .foregroundColor(.textGrey)
                        }
                        
                        // Form fields
                        VStack(spacing: 16) {
                            // Preferred Name
                            FormTextField(
                                placeholder: "Preferred Name",
                                text: $preferredName,
                                keyboardType: .default,
                                textContentType: .givenName,
                                autocapitalization: .words
                            )
                            .focused($focusedField, equals: .preferredName)
                            .submitLabel(.done)
                            .onSubmit { focusedField = nil }
                            
                            // Gender Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender")
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(.textGrey)
                                    .padding(.horizontal, 4)
                                
                                PickerTextField(
                                    placeholder: "Select Gender",
                                    selectedValue: selectedGender.rawValue,
                                    isFocused: focusedField == .gender
                                ) {
                                    focusedField = .gender
                                }
                                .focused($focusedField, equals: .gender)
                            }
                            
                            // Country Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Country")
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(.textGrey)
                                    .padding(.horizontal, 4)
                                
                                PickerTextField(
                                    placeholder: "Select Country",
                                    selectedValue: selectedCountry,
                                    isFocused: focusedField == .country
                                ) {
                                    focusedField = .country
                                }
                                .focused($focusedField, equals: .country)
                            }
                            
                            // Height & Weight with Unit Toggle
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Height & Weight")
                                        .font(AppFonts.lightBody())
                                        .foregroundColor(.textGrey)
                                    
                                    Spacer()
                                    
                                    // Unit Toggle
                                    HStack(spacing: 4) {
                                        Button(action: { useMetric = true }) {
                                            Text("Metric")
                                                .font(AppFonts.smallBody())
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(useMetric ? Color.accentBurntOrange : Color.clear)
                                                .foregroundColor(useMetric ? .white : .textGrey)
                                                .cornerRadius(6)
                                        }
                                        
                                        Button(action: { useMetric = false }) {
                                            Text("Imperial")
                                                .font(AppFonts.smallBody())
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(!useMetric ? Color.accentBurntOrange : Color.clear)
                                                .foregroundColor(!useMetric ? .white : .textGrey)
                                                .cornerRadius(6)
                                        }
                                    }
                                    .padding(2)
                                    .background(Color.backgroundGrey)
                                    .cornerRadius(8)
                                }
                                .padding(.horizontal, 4)
                                
                                HStack(spacing: 12) {
                                    FormTextField(
                                        placeholder: useMetric ? "Height (cm)" : "Height (in)",
                                        text: $height,
                                        keyboardType: .decimalPad
                                    )
                                    .focused($focusedField, equals: .height)
                                    
                                    FormTextField(
                                        placeholder: useMetric ? "Weight (kg)" : "Weight (lb)",
                                        text: $weight,
                                        keyboardType: .decimalPad
                                    )
                                    .focused($focusedField, equals: .weight)
                                }
                            }
                            
                            // Dietary Preferences
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Dietary Preferences")
                                    .font(AppFonts.lightBody())
                                    .foregroundColor(.textGrey)
                                    .padding(.horizontal, 4)
                                
                                Text("Select all that apply")
                                    .font(AppFonts.smallBody())
                                    .foregroundColor(.textGrey.opacity(0.7))
                                    .padding(.horizontal, 4)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 8) {
                                    ForEach(DietaryPreference.allCases, id: \.self) { preference in
                                        SelectionChip(
                                            title: preference.rawValue,
                                            icon: preference.icon,
                                            isSelected: selectedDietaryPreferences.contains(preference)
                                        ) {
                                            if selectedDietaryPreferences.contains(preference) {
                                                selectedDietaryPreferences.remove(preference)
                                            } else {
                                                selectedDietaryPreferences.insert(preference)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // Get Started Button
                    PrimaryButton.primary(
                        title: "Get Started",
                        action: {
                            focusedField = nil
                            getStarted()
                        },
                        isEnabled: isFormValid
                    )
                    .padding(.top, 16)
                    
                    // Skip button
                    Button(action: {
                        focusedField = nil
                        skip()
                    }) {
                        Text("Skip for now")
                            .font(AppFonts.regularBody())
                            .foregroundColor(.textGrey)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            // Pickers that appear as keyboard
            if focusedField == .gender {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        // Toolbar
                        HStack {
                            Spacer()
                            Button("Done") {
                                focusedField = nil
                            }
                            .padding()
                        }
                        .background(Color.backgroundGrey)
                        
                        // Picker
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 200)
                        .background(Color.white)
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: focusedField)
            }
            
            if focusedField == .country {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        // Toolbar
                        HStack {
                            Spacer()
                            Button("Done") {
                                focusedField = nil
                            }
                            .padding()
                        }
                        .background(Color.backgroundGrey)
                        
                        // Picker
                        Picker("Country", selection: $selectedCountry) {
                            ForEach(countries, id: \.self) { country in
                                Text(country).tag(country)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 200)
                        .background(Color.white)
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: focusedField)
            }
        }
    }
    
    private var isFormValid: Bool {
        !preferredName.isEmpty
    }
    
    private func getStarted() {
        print("Get started tapped with:")
        print("Name: \(preferredName)")
        print("Gender: \(selectedGender.rawValue)")
        print("Country: \(selectedCountry)")
        print("Height: \(height) \(useMetric ? "cm" : "in")")
        print("Weight: \(weight) \(useMetric ? "kg" : "lb")")
        print("Dietary Preferences: \(selectedDietaryPreferences.map { $0.rawValue })")
    }
    
    private func skip() {
        print("Skipped onboarding")
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
