import SwiftUI

struct SpreadsheetView: View {
    let community: Community
    @Environment(\.dismiss) var dismiss
    
    // Define column headers
    private let columns = ["Service Provider", "Service Type", "Rating"]
    // Initialize 50 empty rows
    @State private var rows: [[String]] = Array(repeating: ["", "", ""], count: 50)
    
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
                    ForEach(0..<50) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach(0..<3) { colIndex in
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