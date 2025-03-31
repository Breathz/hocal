import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let senderName: String
    
    init(content: String, senderName: String) {
        self.content = content
        self.timestamp = Date()
        self.senderName = senderName
    }
} 