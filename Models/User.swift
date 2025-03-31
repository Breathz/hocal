import SwiftUI

struct User: Codable {
    let username: String
    let birthDate: Date
    var profileImage: UIImage?
    var communities: Int = 0
    var messages: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case username, birthDate, communities, messages
        // Exclude profileImage from Codable as UIImage isn't Codable
    }
} 