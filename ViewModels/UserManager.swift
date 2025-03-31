import SwiftUI

class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    private let accountManager = UserAccountManager()
    
    init() {
        // Check if user was previously logged in
        if let savedUsername = UserDefaults.standard.string(forKey: "currentUsername"),
           let savedUserData = UserDefaults.standard.data(forKey: "currentUser"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            self.currentUser = decodedUser
            self.isAuthenticated = true
        }
    }
    
    func signIn(username: String, password: String) -> Bool {
        if let account = accountManager.verifyAccount(username: username, password: password) {
            let user = User(username: account.username, birthDate: account.birthDate)
            currentUser = user
            isAuthenticated = true
            
            // Save login state
            UserDefaults.standard.set(username, forKey: "currentUsername")
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }
            return true
        }
        return false
    }
    
    func signUp(username: String, password: String, birthDate: Date) -> Bool {
        if accountManager.createAccount(username: username, password: password, birthDate: birthDate) {
            let user = User(username: username, birthDate: birthDate)
            currentUser = user
            isAuthenticated = true
            
            // Save login state
            UserDefaults.standard.set(username, forKey: "currentUsername")
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }
            return true
        }
        return false
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        // Clear saved login state
        UserDefaults.standard.removeObject(forKey: "currentUsername")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
} 