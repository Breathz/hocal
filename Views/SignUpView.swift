import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @Binding var showAuth: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var birthDate = {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let components = DateComponents(year: currentYear - 18, month: 1, day: 1)
        return calendar.date(from: components) ?? Date()
    }()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Calculate minimum allowed date (18 years ago)
    private var minimumDate: Date {
        Calendar.current.date(byAdding: .year, value: -120, to: Date()) ?? Date()
    }
    
    private var maximumDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    private var isUserOver18: Bool {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0 >= 18
    }
    
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
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppSettings.Colors.darkGreen)
                    .padding(.top, 20)
                
                // Sign Up Form
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
                    
                    // Birth Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Birth Date")
                            .font(.subheadline)
                            .foregroundColor(AppSettings.Colors.darkGreen)
                        
                        DatePicker("", selection: $birthDate, in: minimumDate...maximumDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxHeight: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                
                // Sign Up Button
                Button(action: {
                    handleSignUp()
                }) {
                    Text("Sign Up")
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
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleSignUp() {
        // Validate username
        guard !username.isEmpty else {
            alertMessage = "Please enter a username"
            showAlert = true
            return
        }
        
        // Validate password
        guard !password.isEmpty else {
            alertMessage = "Please enter a password"
            showAlert = true
            return
        }
        
        // Validate age
        guard isUserOver18 else {
            alertMessage = "You must be 18 or older to create an account"
            showAlert = true
            return
        }
        
        // Try to create the account
        if userManager.signUp(username: username, password: password, birthDate: birthDate) {
            showAuth = false  // Success - dismiss auth flow
        } else {
            alertMessage = "Username already exists. Please choose another."
            showAlert = true
        }
    }
} 