//
//  PantryView.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
//
//  PantryView.swift
//  Cooki
//
//  Created by Neth Botheju on 20/9/2025.
//
import SwiftUI

struct PantryView: View {

    var body: some View {
        ZStack {
            Color.white
                .clipShape(TopRoundedModal(radius: 30))
                .ignoresSafeArea(edges: .bottom) 
            
            Text("Your Stock")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
