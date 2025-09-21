//
//  FontPreview.swift
//  Cooki
//
//  Created by Neth Botheju on 21/9/2025.
//
import SwiftUI

struct FontListView: View {
    let fontFamilies = UIFont.familyNames.sorted()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(fontFamilies, id: \.self) { family in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Family: \(family)")
                            .font(.headline)
                        
                        ForEach(UIFont.fontNames(forFamilyName: family).sorted(), id: \.self) { name in
                            Text(name)
                                .font(.custom(name, size: 16))
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
            .padding()
        }
    }
}

struct FontListView_Previews: PreviewProvider {
    static var previews: some View {
        FontListView()
            .previewDevice("iPhone 15 Pro")
    }
}
