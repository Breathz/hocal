import SwiftUI

struct CommunitiesPage: View {
    @EnvironmentObject private var userManager: UserManager
    @EnvironmentObject private var communityManager: CommunityManager
    @State private var searchText = ""
    @State private var showAddCommunity = false
    @State private var isSearching = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredCommunities: [Community] {
        if searchText.isEmpty {
            return communityManager.communities
        } else {
            return communityManager.communities.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.state.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search communities", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchText) { _ in
                            isSearching = !searchText.isEmpty
                        }
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            isSearching = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                if isSearching {
                    // Search Results Popup
                    ScrollView {
                        VStack(spacing: 8) {
                            if filteredCommunities.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    
                                    Text("No communities found")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    
                                    Text("Try a different search")
                                        .font(.subheadline)
                                        .foregroundColor(.gray.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                            } else {
                                ForEach(filteredCommunities) { community in
                                    SearchResultRow(community: community)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    // Grid of communities
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(communityManager.communities) { community in
                                NavigationLink(destination: CommunitySpreadsheet(community: community)) {
                                    CommunityCard(community: community, communityManager: communityManager)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showAddCommunity = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppSettings.Colors.darkGreen)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppSettings.Colors.darkGreen)
        .sheet(isPresented: $showAddCommunity) {
            AddCommunityView(communityManager: communityManager)
        }
        .animation(.easeInOut, value: isSearching)
    }
}

struct CommunityCard: View {
    let community: Community
    @EnvironmentObject private var userManager: UserManager
    @ObservedObject var communityManager: CommunityManager
    @State private var showChat = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    var canModify: Bool {
        userManager.currentUser?.username == community.creatorUsername
    }
    
    var body: some View {
        Button(action: {
            showChat = true
        }) {
            VStack {
                if let image = community.image {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                        
                        if canModify {
                            Menu {
                                Button(action: {
                                    showEditSheet = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: {
                                    showDeleteAlert = true
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                    }
                } else {
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 120)
                        
                        if canModify {
                            Menu {
                                Button(action: {
                                    showEditSheet = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: {
                                    showDeleteAlert = true
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(community.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(community.state)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .fullScreenCover(isPresented: $showChat) {
            CommunitySpreadsheet(community: community)
        }
        .sheet(isPresented: $showEditSheet) {
            EditCommunityView(
                communityManager: communityManager,
                community: community,
                isPresented: $showEditSheet
            )
        }
        .alert("Delete Community", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                communityManager.deleteCommunity(community)
            }
        } message: {
            Text("Are you sure you want to delete this community? This action cannot be undone.")
        }
    }
}

struct SearchResultRow: View {
    let community: Community
    @State private var showChat = false
    
    var body: some View {
        Button(action: {
            showChat = true
        }) {
            HStack {
                if let image = community.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(community.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text(community.state)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .fullScreenCover(isPresented: $showChat) {
            CommunitySpreadsheet(community: community)
        }
    }
}

#Preview {
    CommunitiesPage()
} 


