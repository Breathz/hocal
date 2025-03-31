import SwiftUI

struct AuthChoiceView: View {
    @Binding var showAuth: Bool
    @State private var showLogin = false
    @State private var showSignUp = false
    @State private var showTerms = false
    
    var body: some View {
        ZStack {
            AppSettings.Colors.beigeBrown
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Logo/Icon
                Circle()
                    .fill(AppSettings.Colors.darkGreen)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                
                Text("Welcome to Hocal")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppSettings.Colors.darkGreen)
                
                Text("Join your local community to get good recommendations for services for your house and life")
                    .font(.title3)
                    .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                
                // Login Button
                Button(action: {
                    showLogin = true
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Log In")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppSettings.Colors.darkGreen)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                
                // Sign Up Button
                Button(action: {
                    showSignUp = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Sign Up")
                    }
                    .font(.headline)
                    .foregroundColor(AppSettings.Colors.darkGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppSettings.Colors.darkGreen, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Terms and Privacy
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("By continuing, you agree to our ")
                            .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
                        
                        Text("Terms of Service")
                            .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
                            .underline()
                            .onTapGesture {
                                showTerms = true
                            }
                    }
                    
                    HStack(spacing: 0) {
                        Text("and ")
                            .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
                        
                        Text("Privacy Policy")
                            .foregroundColor(AppSettings.Colors.darkGreen.opacity(0.8))
                            .underline()
                            .onTapGesture {
                                showTerms = true
                            }
                    }
                }
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(showAuth: $showAuth)
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView(showAuth: $showAuth)
        }
        .sheet(isPresented: $showTerms) {
            TermsAndPrivacyView(isPresented: $showTerms)
        }
    }
} 