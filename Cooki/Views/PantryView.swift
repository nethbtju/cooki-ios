    import SwiftUI

    struct PantryView: View {
        @State private var searchText = "" // State for the search bar
        @State private var selectedOption: String = "All" // Track selected filter option
        @State private var isGridView = false // Track current view (grid or list)
        
        let filterOptions = ["All", "Sort by location", "Filter"]
        
        var body: some View {
            ZStack {
                // Purple background
                Color.secondaryPurple
                    .ignoresSafeArea()
                
                // Background image
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 1.4,
                           height: UIScreen.main.bounds.height * 1.1,
                           alignment: .top)
                    .clipped()
                    .ignoresSafeArea()
                
                // Modal sheet with text overlay
                VStack {
                    Spacer() // pushes sheet to bottom
                    
                    ZStack(alignment: .topLeading) {
                        // Modal sheet
                        ModalSheet(
                            heightFraction: 0.90,
                            cornerRadius: 27,
                            content: {
                                VStack(spacing: 16) {
                                    // Search bar at the top inside the sheet
                                    SearchBar(text: $searchText, placeholder: "Search pantry items")
                                        .padding(.top, 5)
                                    
                                    // HStack for filter/sort options + toggle icon
                                    HStack(spacing: 12) {
                                        // Filter buttons
                                        ForEach(filterOptions, id: \.self) { option in
                                            FilterButton(
                                                title: option,
                                                isSelected: Binding(
                                                    get: { selectedOption == option },
                                                    set: { _ in selectedOption = option }
                                                )
                                            )
                                        }
                                        
                                        Spacer()
                                        
                                        // Toggle button for list/grid with fixed size
                                        Button(action: {
                                            isGridView.toggle()
                                        }) {
                                            Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                                .font(.system(size: 16))
                                                .foregroundColor(Color.gray)
                                                .frame(width: 40, height: 36) // fixed frame to match filter buttons
                                                .background(Color.white)
                                                .cornerRadius(12)
                                        }
                                    }
                                    
                                    // Placeholder for other content
                                    Spacer()
                                }
                                .padding(20) // default padding for the whole sheet
                            }
                        )
                        
                        // Text overlay at top-left of the sheet
                        Text("Your Pantry")
                            .font(AppFonts.heading())
                            .foregroundColor(.white)
                            .padding(.top, 120)
                            .padding(.leading, 24)
                    }
                }
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
