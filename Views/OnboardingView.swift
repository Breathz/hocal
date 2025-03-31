import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var showAuthChoice = false
    
    var body: some View {
        ZStack {
            AppSettings.Colors.beigeBrown
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo/App Name
                Text("Welcome to Hocal")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(AppSettings.Colors.darkGreen)
                    .multilineTextAlignment(.center)
                
                // App Description
                VStack(spacing: 20) {
                    OnboardingCard(
                        icon: "person.3.fill",
                        title: "Join Communities",
                        description: "Connect with people who share your interests"
                    )
                    
                    OnboardingCard(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "Local Services",
                        description: "Find local recommendations for services"
                    )
                    
                    OnboardingCard(
                        icon: "map.fill",
                        title: "Stay Local",
                        description: "Find communities in your area"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    withAnimation {
                        showAuthChoice = true
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppSettings.Colors.darkGreen)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showAuthChoice) {
            AuthChoiceView(showAuth: $showOnboarding)
        }
    }
}

struct OnboardingCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(AppSettings.Colors.darkGreen)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppSettings.Colors.darkGreen)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
} 