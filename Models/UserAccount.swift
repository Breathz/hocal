import Foundation

struct UserAccount: Codable, Identifiable {
    let id: UUID
    let username: String
    let password: String
    let birthDate: Date
    
    init(username: String, password: String, birthDate: Date) {
        self.id = UUID()
        self.username = username
        self.password = password
        self.birthDate = birthDate
    }
} 