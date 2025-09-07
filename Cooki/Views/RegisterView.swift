//
//  RegisterView.swift
//  Cooki
//
//  Created by Neth Botheju on 7/9/2025.
//
import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    @State private var navigateToUserDetails = false
    
    var body: some View {
        ZStack {
            // Purple background
            Color.secondaryPurple
                .ignoresSafeArea()
            
            // Background image (oversized, top-aligned)
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 1.4,
                       height: UIScreen.main.bounds.height * 1.1,
                       alignment: .top)
                .clipped()
                .ignoresSafeArea()
            
            VStack() {
                // Logo
                Image("CookieIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 140)
                // White modal sheet (always centered)
                ModalSheet(
                    heightFraction: 0.60,
                    cornerRadius: 27,
                    content: {
                        ScrollView(.vertical, showsIndicators: false) {
                            Spacer().padding(.bottom, 48)
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading) {
                                    Text("Welcome to your new pantry pal!")
                                        .font(AppFonts.heading())
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true) // allow vertical expansion
                                        .padding(.trailing, 10)

                                    // Email
                                    TextField("Email Address", text: $email)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.textGrey)
                                        )
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .focused($focusedField, equals: .email)
                                        .font(AppFonts.lightBody())
                                        .foregroundColor(Color.textGrey)
                                    
                                    // Password
                                    SecureField("Password", text: $email)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.textGrey)
                                        )
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .focused($focusedField, equals: .email)
                                        .font(AppFonts.lightBody())
                                        .foregroundColor(Color.textGrey)
                                }
                                .padding(.bottom, 8)
                            }.padding(24)
                        }
                    }
                )
                
                Button("Let's go!") {}
                .navigationDestination(isPresented: $navigateToUserDetails) {
                    UserDetailsView()
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
