import SwiftUI

struct Community: Codable, Identifiable {
    let id: UUID
    let name: String
    let state: String
    let creatorUsername: String
    let imageData: Data?
    let createdAt: Date
    
    init(name: String, state: String, creatorUsername: String, image: UIImage?) {
        self.id = UUID()
        self.name = name
        self.state = state
        self.creatorUsername = creatorUsername
        self.imageData = image?.jpegData(compressionQuality: 0.7)
        self.createdAt = Date()
    }
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
} 