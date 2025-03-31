import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @Binding var showAuth: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AppSettings.Colors.beigeBrown
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppSettings.Colors.darkGreen)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Title
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppSettings.Colors.darkGreen)
                    .padding(.top, 20)
                
                // Login Form
                VStack(spacing: 20) {
                    // Username Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.subheadline)
                            .foregroundColor(AppSettings.Colors.darkGreen)
                        
                        TextField("", text: $username)
                            .textFieldStyle(CustomLoginFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(AppSettings.Colors.darkGreen)
                        
                        SecureField("", text: $password)
                            .textFieldStyle(CustomLoginFieldStyle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                
                // Login Button
                Button(action: {
                    handleLogin()
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppSettings.Colors.darkGreen)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .alert("Login Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleLogin() {
        // Basic validation
        guard !username.isEmpty else {
            alertMessage = "Please enter your username"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Please enter your password"
            showAlert = true
            return
        }
        
        // Try to sign in
        if userManager.signIn(username: username, password: password) {
            showAuth = false  // Success - dismiss auth flow
        } else {
            alertMessage = "Invalid username or password"
            showAlert = true
        }
    }
}

// Custom TextField Style for Login
struct CustomLoginFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
} 