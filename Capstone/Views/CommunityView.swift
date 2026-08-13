//
//  CommunityView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct CommunityView: View {
    @State private var selectedFeedTab: FeedType = .following
    
    enum FeedType: String, CaseIterable {
        case following = "Following", trending = "Trending"
        case recent = "Recent", nearby = "Nearby"
        
        var icon: String {
            switch self {
            case .following: return "person.2.fill"
            case .trending: return "flame.fill"
            case .recent: return "clock.fill"
            case .nearby: return "mappin.and.ellipse"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Feed tabs, equivalent to .feed-tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(FeedType.allCases, id: \.self) { tab in
                            Button {
                                selectedFeedTab = tab
                            } label: {
                                Label(tab.rawValue, systemImage: tab.icon)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedFeedTab == tab
                                            ? AnyView(LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")], startPoint: .leading, endPoint: .trailing))
                                            : AnyView(Color.white)
                                    )
                                    .foregroundColor(selectedFeedTab == tab ? .white : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Community feed coming soon")
                    .foregroundColor(.secondary)
                    .padding(.top, 60)
            }
            .padding(.vertical)
        }
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Community")
    }
}
