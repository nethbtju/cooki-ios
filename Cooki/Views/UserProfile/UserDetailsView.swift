//
//  UserDetailsView.swift
//  Cooki
//
//  Modified by Neth Botheju on 29/11/2025.
//
import SwiftUI

public struct UserDetailsView: View {
    public var body: some View {
        MainLayout(header: { LogoHeader(enableBackButton: false) }, content: { UserDetailsContent() })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .interactiveDismissDisabled(true) // Prevent swipe back gesture
    }
}

// MARK: - User Details Content
struct UserDetailsContent: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var preferredName: String = ""
    @State private var selectedGender: String = ""
    @State private var selectedCountry: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var useMetric: Bool = true
    @State private var selectedDietaryPreferences: Set<DietaryPreference> = []

    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case preferredName, gender, country, height, weight
    }

    let gender = ["Male", "Female", "Non-Binary", "Prefer not to say"]

    let countries = [
        "United States", "Canada", "United Kingdom", "Australia", "Germany",
        "France", "Italy", "Spain", "Japan", "China", "India", "Brazil",
        "Mexico", "Netherlands", "Sweden", "Norway", "Denmark", "Finland",
        "New Zealand", "Singapore", "South Korea", "Thailand", "Vietnam"
    ].sorted()

    var body: some View {
        // White modal
        ZStack {
            Color.white
                .clipShape(TopRoundedModal())
                .ignoresSafeArea(edges: .bottom)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to your new pantry manager! 🍪")
                            .font(AppFonts.heading())
                            .foregroundStyle(Color.textBlack)
                        Text("Help us personalize your experience")
                            .font(AppFonts.regularBody())
                            .foregroundStyle(Color.textGrey)
                    }
                    
                    // Form fields
                    VStack(spacing: 16) {
                        // Preferred Name
                        FormTextField(
                            placeholder: "Preferred Name",
                            text: $preferredName,
                            keyboardType: .default,
                            textContentType: .givenName,
                            autocapitalization: .words,
                            isFocused: focusedField == .preferredName
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
                                placeholder: "Gender",
                                isFocused: focusedField == .gender,
                                selectedValue: $selectedGender,
                                options: gender
                            )
                            .onTapGesture {
                                focusedField = .gender
                            }
                        }
                        
                        // Country Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Country")
                                .font(AppFonts.lightBody())
                                .foregroundColor(.textGrey)
                                .padding(.horizontal, 4)
                            
                            PickerTextField(
                                placeholder: "Country",
                                isFocused: focusedField == .country,
                                selectedValue: $selectedCountry,
                                options: countries
                            )
                            .onTapGesture {
                                focusedField = .country
                            }
                        }
                        
                        // Height & Weight
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
                                    keyboardType: .decimalPad,
                                    isFocused: focusedField == .height
                                )
                                .focused($focusedField, equals: .height)
                                
                                FormTextField(
                                    placeholder: useMetric ? "Weight (kg)" : "Weight (lb)",
                                    text: $weight,
                                    keyboardType: .decimalPad,
                                    isFocused: focusedField == .weight
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
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
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
                    
                    // Error message
                    if let error = appViewModel.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                            Text(error)
                                .font(AppFonts.smallBody())
                        }
                        .foregroundColor(.textRed)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.textRed.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Get Started Button
                    PrimaryButton.primary(
                        title: appViewModel.isLoading ? "" : "Get Started",
                        action: {
                            focusedField = nil
                            Task { await getStarted() }
                        },
                        isEnabled: isFormValid && !appViewModel.isLoading
                    )
                    .overlay {
                        if appViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .padding(.top, 16)
                    
                    // Skip button
                    Button(action: {
                        focusedField = nil
                        Task { await skip() }
                    }) {
                        Text("Skip for now")
                            .font(AppFonts.regularBody())
                            .foregroundColor(.textGrey)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(appViewModel.isLoading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 48)
            }
        }
    }

    // MARK: - Validation
    private var isFormValid: Bool {
        !preferredName.isEmpty
    }

    // MARK: - Actions
    private func getStarted() async {
        guard !preferredName.isEmpty else {
            appViewModel.errorMessage = "Please enter your name"
            appViewModel.showError = true
            return
        }

        let displayName = preferredName

        let updatedPreferences = User.UserPreferences(
            dietaryPreferences: Array(selectedDietaryPreferences),
            allergies: [],
            dislikedIngredients: [],
            servingsPerMeal: 2,
            notificationsEnabled: true
        )

        await appViewModel.completeUserRegistration(
            displayName: displayName,
            preferences: updatedPreferences
        )

        if appViewModel.isAuthenticated, AppConfig.enableDebugLogging {
            print("✅ UserDetailsView: Registration completed successfully")
            print("   Name: \(displayName)")
            print("   Preferences saved")
            print("   Pantry created")
        }
    }

    private func skip() async {
        guard let email = appViewModel.currentUser?.email else { return }

        let defaultDisplayName = email.components(separatedBy: "@").first ?? "User"
        let defaultPreferences = User.UserPreferences()

        await appViewModel.completeUserRegistration(
            displayName: defaultDisplayName,
            preferences: defaultPreferences
        )

        if AppConfig.enableDebugLogging {
            print("⏭️ UserDetailsView: Skipped onboarding")
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .environmentObject(AppViewModel())
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
