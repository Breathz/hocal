import SwiftUI

class CommunityManager: ObservableObject {
    @Published var communities: [Community] = []
    private let communitiesKey = "savedCommunities"
    
    init() {
        loadCommunities()
    }
    
    func addCommunity(name: String, state: String, creatorUsername: String, image: UIImage?) -> Bool {
        let newCommunity = Community(name: name, state: state, creatorUsername: creatorUsername, image: image)
        communities.append(newCommunity)
        saveCommunities()
        return true
    }
    
    func getCommunities(forUsername username: String) -> [Community] {
        return communities.filter { $0.creatorUsername == username }
    }
    
    private func saveCommunities() {
        if let encoded = try? JSONEncoder().encode(communities) {
            UserDefaults.standard.set(encoded, forKey: communitiesKey)
            UserDefaults.standard.synchronize() // Force save
        }
    }
    
    private func loadCommunities() {
        if let data = UserDefaults.standard.data(forKey: communitiesKey),
           let decoded = try? JSONDecoder().decode([Community].self, from: data) {
            communities = decoded
        }
    }
    
    func deleteCommunity(_ community: Community) {
        guard let currentUser = UserDefaults.standard.string(forKey: "currentUsername"),
              currentUser == community.creatorUsername else {
            return
        }
        
        withAnimation {
            communities.removeAll { $0.id == community.id }
            saveCommunities()
            objectWillChange.send() // Explicitly notify observers
        }
    }
    
    func updateCommunity(_ community: Community, newName: String, newState: String, newImage: UIImage?) {
        guard let currentUser = UserDefaults.standard.string(forKey: "currentUsername"),
              currentUser == community.creatorUsername else {
            return
        }
        
        if let index = communities.firstIndex(where: { $0.id == community.id }) {
            let updatedCommunity = Community(
                name: newName,
                state: newState,
                creatorUsername: community.creatorUsername,
                image: newImage
            )
            communities[index] = updatedCommunity
            saveCommunities()
        }
    }
} 