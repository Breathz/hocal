import SwiftUI

class CommunitiesViewModel: ObservableObject {
    @Published var communities: [Community] = []
    
    func addCommunity(name: String, state: String, image: UIImage?) {
        let community = Community(
            name: name,
            state: state,
            creatorUsername: UIDevice.current.name, // Temporary, should use actual user
            image: image
        )
        communities.append(community)
    }
} 