import SwiftUI

struct SearchPage: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            
            // Search results would go here
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppSettings.Colors.darkGreen)
    }
} 