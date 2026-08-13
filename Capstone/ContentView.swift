//
//  ContentView.swift
//  Capstone
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct ContentView: View {
    // Tracks which tab is active, like tracking which URL path
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, explore, locations, community, upload
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Each tab wraps its root view in a NavigationStack so
            // pushing detail screens (like a post detail) works
            // independently per tab — same idea as each Django app
            // (pages, notes) having its own urls.py
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(Tab.home)
            
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "safari.fill")
            }
            .tag(Tab.explore)
            
            NavigationStack {
                LocationsView()
            }
            .tabItem {
                Label("Locations", systemImage: "mappin.and.ellipse")
            }
            .tag(Tab.locations)
            
            NavigationStack {
                CommunityView()
            }
            .tabItem {
                Label("Community", systemImage: "person.2.fill")
            }
            .tag(Tab.community)
            
            NavigationStack {
                UploadView()
            }
            .tabItem {
                Label("Share", systemImage: "plus.circle.fill")
            }
            .tag(Tab.upload)
        }
        // Matches your navbar's brand gradient accent color
        .tint(Color(hex: "667eea"))
    }
}


#Preview {
    ContentView()
}
