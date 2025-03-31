import SwiftUI

struct TermsAndPrivacyView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                AppSettings.Colors.beigeBrown.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    TabView(selection: $currentPage) {
                        // Terms of Service
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Terms of Service")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("By using Hocal, you agree to:")
                                .fontWeight(.medium)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                BulletPoint("Provide accurate information")
                                BulletPoint("Respect other users and their privacy")
                                BulletPoint("Not share inappropriate content")
                                BulletPoint("Be at least 18 years old")
                                BulletPoint("Take responsibility for your interactions")
                            }
                        }
                        .padding()
                        .tag(0)
                        
                        // Privacy Policy
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Privacy Policy")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("We collect and protect:")
                                .fontWeight(.medium)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                BulletPoint("Basic account information")
                                BulletPoint("Community participation data")
                                BulletPoint("Messages within communities")
                                BulletPoint("Profile information")
                                BulletPoint("Usage statistics")
                            }
                        }
                        .padding()
                        .tag(1)
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    // Page Indicator
                    HStack {
                        Circle()
                            .fill(currentPage == 0 ? AppSettings.Colors.darkGreen : Color.gray)
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(currentPage == 1 ? AppSettings.Colors.darkGreen : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                    
                    Button("I Understand") {
                        isPresented = false
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppSettings.Colors.darkGreen)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppSettings.Colors.darkGreen)
                    }
                }
            }
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .foregroundColor(AppSettings.Colors.darkGreen)
            Text(text)
        }
        .foregroundColor(AppSettings.Colors.darkGreen)
    }
} 
