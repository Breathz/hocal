import SwiftUI

struct HomePage: View {
    @EnvironmentObject var communityManager: CommunityManager
    
    var popularCommunities: [Community] {
        // For now, just show all communities
        // Later you can add a popularity metric and sort by it
        Array(communityManager.communities
            .sorted { $0.createdAt > $1.createdAt } // Sort by newest first
            .prefix(6)) // Show top 6 communities
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Popular Communities")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if popularCommunities.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "house.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("No communities yet")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Communities will appear here")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(popularCommunities) { community in
                            PopularCommunityCard(community: community)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppSettings.Colors.darkGreen)
    }
}

struct PopularCommunityCard: View {
    let community: Community
    @State private var showChat = false
    
    var body: some View {
        Button(action: {
            showChat = true
        }) {
            VStack(alignment: .leading) {
                if let image = community.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 100)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(community.name)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(community.state)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    HStack {
                        Image(systemName: "person.fill")
                        Text(community.creatorUsername)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                }
                .padding(8)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .fullScreenCover(isPresented: $showChat) {
            CommunityChat(community: community)
        }
    }
} 