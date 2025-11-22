//
//  SearchBar.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//


//
//  SearchBar.swift
//  Cooki
//
//  Created by Rohit Valanki on 7/9/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10) // reduced padding to make it shorter
        .background(Color.backgroundGrey)
        .cornerRadius(16.5)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var searchText = ""
    
    static var previews: some View {
        SearchBar(text: $searchText)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
