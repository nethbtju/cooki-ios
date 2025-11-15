//
//  SelectReceiptMethod.swift
//  Cooki
//
//  Created by Neth Botheju on 6/10/2025.
//
import SwiftUI

struct AddPantryItemView: View {
    var body: some View {
        VStack {
            Text("Add to pantry")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            VStack(spacing: 20) { // consistent spacing between buttons
                AddItemOptionButton(
                    iconName: "camera.fill",
                    title: "Use Camera",
                    subtitle: "Take a photo of your receipt",
                    primaryColor: Color.accentBurntOrange,
                    secondaryColor: Color.accentPeach
                ) {
                    print("Camera tapped!")
                }
                
                Divider()
                    .background(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                
                AddItemOptionButton(
                    iconName: "photo.on.rectangle",
                    title: "Upload eReciept",
                    subtitle: "Choose from your files",
                    primaryColor: Color.accentViolet,
                    secondaryColor: Color.secondaryPurple
                    
                ) {
                    print("Upload tapped!")
                }
            }
            .padding(.horizontal)
            Spacer().frame(height: 60)
        }
    }
}

struct AddPantryItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddPantryItemView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
