//
//  ContentView.swift
//  Capstone
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct ContentView: View {
    let loggedInUser: UserAccount
    @StateObject private var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, explore, locations, community, profile
    }
    
    init(loggedInUser: UserAccount) {
        self.loggedInUser = loggedInUser
        let vm = AuthViewModel()
        vm.currentUser = loggedInUser
        vm.isAuthenticated = true
        _authViewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(Tab.home)
            
            NavigationStack {
                ExploreView()
            }
            .tabItem { Label("Explore", systemImage: "safari.fill") }
            .tag(Tab.explore)
            
            NavigationStack {
                LocationsView()
            }
            .tabItem { Label("Locations", systemImage: "mappin.and.ellipse") }
            .tag(Tab.locations)
            
            NavigationStack {
                CommunityView()
            }
            .tabItem { Label("Community", systemImage: "person.2.fill") }
            .tag(Tab.community)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
            .tag(Tab.profile)
        }
        .tint(Color(hex: "667eea"))
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView(
        loggedInUser: UserAccount(
            username: "preview_user",
            email: "preview@example.com",
            passwordHash: "preview_hash"
        )
    )
}
