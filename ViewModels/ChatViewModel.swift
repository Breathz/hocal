import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentMessage = ""
    let userName = UIDevice.current.name // For demo purposes, using device name as user name
    
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let message = Message(content: currentMessage, senderName: userName)
        messages.append(message)
        currentMessage = ""
    }
} 