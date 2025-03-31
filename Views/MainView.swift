import SwiftUI

struct MainView: View {
    @State private var selectedTab = "Home"
    @State private var showMenu = false
    @StateObject private var communityManager = CommunityManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // App Title and Menu Button
                HStack {
                    Text("Hocal")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Menu Button
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .padding(.bottom, 10)
                
                // Navigation Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(["Home", "Your Communities", "About Us", "Search", "Your Profile"], id: \.self) { tab in
                            Button(action: {
                                selectedTab = tab
                            }) {
                                VStack {
                                    Text(tab)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 8)
                                    
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(selectedTab == tab ? .white : .clear)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    HomePage()
                        .tag("Home")
                        .environmentObject(communityManager)
                    
                    CommunitiesPage()
                        .tag("Your Communities")
                        .environmentObject(communityManager)
                    
                    AboutUsPage()
                        .tag("About Us")
                    
                    SearchPage()
                        .tag("Search")
                    
                    ProfileView()
                        .tag("Your Profile")
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(AppSettings.Colors.darkGreen)
            .edgesIgnoringSafeArea(.all)
            // Navigation Menu
            .sheet(isPresented: $showMenu) {
                NavigationMenuView(selectedTab: $selectedTab, isPresented: $showMenu)
            }
        }
        .environmentObject(communityManager)
    }
}

// Navigation Menu View
struct NavigationMenuView: View {
    @Binding var selectedTab: String
    @Binding var isPresented: Bool
    @EnvironmentObject var userManager: UserManager
    
    let menuItems = ["Home", "Your Communities", "About Us", "Search", "Your Profile"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppSettings.Colors.darkGreen.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    Text("Menu")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    // Menu Items
                    ForEach(menuItems, id: \.self) { item in
                        Button(action: {
                            withAnimation {
                                selectedTab = item
                                isPresented = false
                            }
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: menuIcon(for: item))
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                                
                                Text(item)
                                    .font(.system(size: 18, weight: .medium))
                                
                                Spacer()
                                
                                if selectedTab == item {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTab == item ? Color.white.opacity(0.2) : Color.clear)
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // Sign Out Button
                    Button(action: {
                        userManager.signOut()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 30)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func menuIcon(for item: String) -> String {
        switch item {
        case "Home":
            return "house.fill"
        case "Your Communities":
            return "person.3.fill"
        case "About Us":
            return "info.circle.fill"
        case "Search":
            return "magnifyingglass"
        case "Your Profile":
            return "person.circle.fill"
        default:
            return "circle.fill"
        }
    }
} 