import SwiftUI

struct CommunitySpreadsheet: View {
    let community: Community
    @Environment(\.dismiss) var dismiss
    
    // Move the properties inside the struct
    private let columns = ["Name", "Service", "Phone", "Rating", "Notes"]
    @State private var rows = Array(repeating: Array(repeating: "", count: 5), count: 30)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                }
                
                if let image = community.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                Text(community.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(AppSettings.Colors.darkGreen)
            
            // Column Headers
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { column in
                    Text(column)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppSettings.Colors.darkGreen)
                }
            }
            
            // Spreadsheet rows
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<30) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach(0..<5) { colIndex in
                                TextField("", text: $rows[rowIndex][colIndex])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                            }
                        }
                        .background(rowIndex % 2 == 0 ? Color(.systemBackground) : Color(.secondarySystemBackground))
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

// Preview provider
struct CommunitySpreadsheet_Previews: PreviewProvider {
    static var previews: some View {
        CommunitySpreadsheet(community: Community(
            name: "Test Community",
            state: "California",
            creatorUsername: "test",
            image: nil
        ))
    }
} 