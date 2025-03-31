import SwiftUI

struct AboutUsPage: View {
    var body: some View {
        VStack {
            Text("About Us")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("Learn more about our mission")
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 5)
            
            // Add about us content here
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppSettings.Colors.darkGreen)
    }
} 