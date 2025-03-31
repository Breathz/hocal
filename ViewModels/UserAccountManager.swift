import Foundation

class UserAccountManager: ObservableObject {
    @Published var accounts: [UserAccount] = []
    private let accountsKey = "savedAccounts"
    
    init() {
        loadAccounts()
    }
    
    func createAccount(username: String, password: String, birthDate: Date) -> Bool {
        // Check if username already exists
        guard !accounts.contains(where: { account in
            account.username.lowercased() == username.lowercased()
        }) else {
            return false
        }
        
        let newAccount = UserAccount(username: username, password: password, birthDate: birthDate)
        accounts.append(newAccount)
        saveAccounts()
        return true
    }
    
    func verifyAccount(username: String, password: String) -> UserAccount? {
        return accounts.first { account in
            account.username.lowercased() == username.lowercased() && 
            account.password == password
        }
    }
    
    private func saveAccounts() {
        if let encoded = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(encoded, forKey: accountsKey)
        }
    }
    
    private func loadAccounts() {
        if let data = UserDefaults.standard.data(forKey: accountsKey),
           let decoded = try? JSONDecoder().decode([UserAccount].self, from: data) {
            accounts = decoded
        }
    }
} 