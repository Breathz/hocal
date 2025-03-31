//
//  ContentView.swift
//  Hocal
//
//  Created by Arav Sachdeva on 1/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userManager = UserManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if userManager.isAuthenticated {
                MainView()
                    .environmentObject(userManager)
            } else if !hasSeenOnboarding {
                OnboardingView(showOnboarding: $hasSeenOnboarding)
                    .transition(.opacity)
                    .environmentObject(userManager)
            } else {
                AuthChoiceView(showAuth: $hasSeenOnboarding)
                    .environmentObject(userManager)
            }
        }
    }
}

#Preview {
    ContentView()
}
